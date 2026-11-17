#include "VNHDriveableVehicle.h"
#include "VNHPlayerCharacter.h"
#include "Components/BoxComponent.h"
#include "Components/StaticMeshComponent.h"
#include "Camera/CameraComponent.h"
#include "GameFramework/SpringArmComponent.h"
#include "GameFramework/PlayerController.h"
#include "Components/InputComponent.h"
#include "Engine/World.h"

AVNHDriveableVehicle::AVNHDriveableVehicle()
{
    PrimaryActorTick.bCanEverTick = true;
    AutoPossessAI = EAutoPossessAI::Disabled;

    CollisionBox = CreateDefaultSubobject<UBoxComponent>(TEXT("VehicleCollision"));
    SetRootComponent(CollisionBox);
    CollisionBox->SetBoxExtent(FVector(220.0f, 95.0f, 65.0f));
    CollisionBox->SetCollisionProfileName(TEXT("Pawn"));

    VehicleMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("VehicleMesh"));
    VehicleMesh->SetupAttachment(CollisionBox);
    VehicleMesh->SetCollisionEnabled(ECollisionEnabled::NoCollision);

    CameraBoom = CreateDefaultSubobject<USpringArmComponent>(TEXT("VehicleCameraBoom"));
    CameraBoom->SetupAttachment(CollisionBox);
    CameraBoom->SetRelativeLocation(FVector(0.0f, 0.0f, 120.0f));
    CameraBoom->TargetArmLength = 650.0f;
    CameraBoom->bEnableCameraLag = true;
    CameraBoom->CameraLagSpeed = 5.0f;
    CameraBoom->bDoCollisionTest = true;

    VehicleCamera = CreateDefaultSubobject<UCameraComponent>(TEXT("VehicleCamera"));
    VehicleCamera->SetupAttachment(CameraBoom, USpringArmComponent::SocketName);
}

void AVNHDriveableVehicle::Tick(float DeltaSeconds)
{
    Super::Tick(DeltaSeconds);
    if (!Controller) return;

    if (bBrakeInput)
    {
        CurrentSpeed = FMath::FInterpConstantTo(CurrentSpeed, 0.0f, DeltaSeconds, BrakeDeceleration);
    }
    else if (!FMath::IsNearlyZero(ThrottleInput))
    {
        const float TargetLimit = ThrottleInput >= 0.0f ? MaxForwardSpeed : -MaxReverseSpeed;
        CurrentSpeed += ThrottleInput * Acceleration * DeltaSeconds;
        CurrentSpeed = FMath::Clamp(CurrentSpeed, -MaxReverseSpeed, MaxForwardSpeed);
        if ((ThrottleInput > 0.0f && CurrentSpeed > TargetLimit) ||
            (ThrottleInput < 0.0f && CurrentSpeed < TargetLimit))
        {
            CurrentSpeed = TargetLimit;
        }
    }
    else
    {
        CurrentSpeed = FMath::FInterpConstantTo(CurrentSpeed, 0.0f, DeltaSeconds, CoastDeceleration);
    }

    const float SpeedFactor = FMath::Clamp(FMath::Abs(CurrentSpeed) / 500.0f, 0.0f, 1.0f);
    if (!FMath::IsNearlyZero(CurrentSpeed))
    {
        const float ReverseSign = CurrentSpeed >= 0.0f ? 1.0f : -1.0f;
        AddActorLocalRotation(FRotator(0.0f, SteeringInput * SteeringRate * SpeedFactor * ReverseSign * DeltaSeconds, 0.0f));
        FHitResult Hit;
        AddActorLocalOffset(FVector(CurrentSpeed * DeltaSeconds, 0.0f, 0.0f), true, &Hit);
        if (Hit.IsValidBlockingHit()) CurrentSpeed = 0.0f;
    }
}

void AVNHDriveableVehicle::SetVehicleInput(float Throttle, float Steering)
{
    ThrottleInput = FMath::Clamp(Throttle, -1.0f, 1.0f);
    SteeringInput = FMath::Clamp(Steering, -1.0f, 1.0f);
}

void AVNHDriveableVehicle::SetBrakeInput(bool bBraking)
{
    bBrakeInput = bBraking;
}

float AVNHDriveableVehicle::GetSpeedKmh() const
{
    return FMath::Abs(CurrentSpeed) * 0.036f;
}

void AVNHDriveableVehicle::Interact_Implementation(AActor* InteractingActor)
{
    AVNHPlayerCharacter* Passenger = Cast<AVNHPlayerCharacter>(InteractingActor);
    if (!Passenger || CurrentPassenger || !Passenger->GetController()) return;

    APlayerController* PC = Cast<APlayerController>(Passenger->GetController());
    if (!PC) return;

    CurrentPassenger = Passenger;
    VehicleController = PC;
    Passenger->SetMoveInput(0.0f, 0.0f);
    Passenger->SetActorHiddenInGame(true);
    Passenger->SetActorEnableCollision(false);
    Passenger->SetActorTickEnabled(false);
    PC->Possess(this);
}

void AVNHDriveableVehicle::ExitVehicle()
{
    if (!VehicleController || !CurrentPassenger) return;
    APlayerController* PC = VehicleController;
    AVNHPlayerCharacter* Passenger = CurrentPassenger;

    const FVector ExitLocation = GetActorLocation() + GetActorRightVector() * 300.0f + FVector(0.0f, 0.0f, 30.0f);
    Passenger->SetActorLocation(ExitLocation, false, nullptr, ETeleportType::TeleportPhysics);
    Passenger->SetActorRotation(FRotator(0.0f, GetActorRotation().Yaw, 0.0f));
    Passenger->SetActorHiddenInGame(false);
    Passenger->SetActorEnableCollision(true);
    Passenger->SetActorTickEnabled(true);

    PC->Possess(Passenger);
    CurrentPassenger = nullptr;
    VehicleController = nullptr;
    ThrottleInput = 0.0f;
    SteeringInput = 0.0f;
    bBrakeInput = false;
    CurrentSpeed = 0.0f;
}

void AVNHDriveableVehicle::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
    Super::SetupPlayerInputComponent(PlayerInputComponent);
    check(PlayerInputComponent);
    PlayerInputComponent->BindAxis(TEXT("VehicleThrottle"), this, &AVNHDriveableVehicle::ThrottleAxis);
    PlayerInputComponent->BindAxis(TEXT("VehicleSteer"), this, &AVNHDriveableVehicle::SteeringAxis);
    PlayerInputComponent->BindAction(TEXT("VehicleBrake"), IE_Pressed, this, &AVNHDriveableVehicle::BrakePressed);
    PlayerInputComponent->BindAction(TEXT("VehicleBrake"), IE_Released, this, &AVNHDriveableVehicle::BrakeReleased);
    PlayerInputComponent->BindAction(TEXT("ExitVehicle"), IE_Pressed, this, &AVNHDriveableVehicle::ExitPressed);
}
void AVNHDriveableVehicle::ThrottleAxis(float Value) { ThrottleInput = FMath::Clamp(Value, -1.0f, 1.0f); }
void AVNHDriveableVehicle::SteeringAxis(float Value) { SteeringInput = FMath::Clamp(Value, -1.0f, 1.0f); }
void AVNHDriveableVehicle::BrakePressed() { SetBrakeInput(true); }
void AVNHDriveableVehicle::BrakeReleased() { SetBrakeInput(false); }
void AVNHDriveableVehicle::ExitPressed() { ExitVehicle(); }
