#include "VNHVehiclePawn.h"
#include "VNHTrafficAIController.h"
#include "AIController.h"
#include "Camera/CameraComponent.h"
#include "Components/InputComponent.h"
#include "Components/StaticMeshComponent.h"
#include "GameFramework/Character.h"
#include "GameFramework/Controller.h"
#include "GameFramework/SpringArmComponent.h"
#include "UObject/ConstructorHelpers.h"

AVNHVehiclePawn::AVNHVehiclePawn()
{
    PrimaryActorTick.bCanEverTick = true;
    VehicleBody = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("VehicleBody"));
    SetRootComponent(VehicleBody);
    VehicleBody->SetCollisionProfileName(TEXT("Vehicle"));
    VehicleBody->SetSimulatePhysics(false);

    static ConstructorHelpers::FObjectFinder<UStaticMesh> BodyMesh(TEXT("/Engine/BasicShapes/Cube.Cube"));
    if (BodyMesh.Succeeded())
    {
        VehicleBody->SetStaticMesh(BodyMesh.Object);
        VehicleBody->SetRelativeScale3D(FVector(2.4f, 1.05f, 0.55f));
        VehicleBody->SetCollisionProfileName(TEXT("BlockAll"));
    }

    static ConstructorHelpers::FObjectFinder<UStaticMesh> WheelMesh(TEXT("/Engine/BasicShapes/Cylinder.Cylinder"));
    if (WheelMesh.Succeeded())
    {
        const FVector WheelPositions[] = {
            FVector(145.0f, 95.0f, -28.0f), FVector(145.0f, -95.0f, -28.0f),
            FVector(-145.0f, 95.0f, -28.0f), FVector(-145.0f, -95.0f, -28.0f)
        };
        for (int32 Index = 0; Index < 4; ++Index)
        {
            UStaticMeshComponent* Wheel = CreateDefaultSubobject<UStaticMeshComponent>(
                *FString::Printf(TEXT("Wheel_%d"), Index));
            Wheel->SetupAttachment(VehicleBody);
            Wheel->SetAbsolute(false, false, true);
            Wheel->SetStaticMesh(WheelMesh.Object);
            Wheel->SetRelativeLocation(WheelPositions[Index]);
            Wheel->SetRelativeRotation(FRotator(90.0f, 0.0f, 0.0f));
            Wheel->SetRelativeScale3D(FVector(0.36f, 0.18f, 0.36f));
            Wheel->SetCollisionEnabled(ECollisionEnabled::NoCollision);
            WheelMeshes.Add(Wheel);
        }
    }

    CameraBoom = CreateDefaultSubobject<USpringArmComponent>(TEXT("VehicleCameraBoom"));
    CameraBoom->SetupAttachment(VehicleBody);
    CameraBoom->TargetArmLength = 650.0f;
    CameraBoom->SetRelativeLocation(FVector(-80.0f, 0.0f, 140.0f));
    CameraBoom->bUsePawnControlRotation = true;
    CameraBoom->bEnableCameraLag = true;
    CameraBoom->CameraLagSpeed = 5.0f;

    VehicleCamera = CreateDefaultSubobject<UCameraComponent>(TEXT("VehicleCamera"));
    VehicleCamera->SetupAttachment(CameraBoom, USpringArmComponent::SocketName);
    VehicleCamera->bUsePawnControlRotation = false;

    AIControllerClass = AVNHTrafficAIController::StaticClass();
    AutoPossessAI = EAutoPossessAI::PlacedInWorldOrSpawned;
}

void AVNHVehiclePawn::Tick(float DeltaSeconds)
{
    Super::Tick(DeltaSeconds);

    if (!GetController()) return;

    if (CurrentFuel <= 0.0f)
    {
        CurrentFuel = 0.0f;
        ThrottleInput = 0.0f;
    }
    else if (!FMath::IsNearlyZero(ThrottleInput) && FMath::Abs(CurrentSpeed) > 10.0f)
    {
        CurrentFuel = FMath::Max(0.0f, CurrentFuel - FuelConsumptionPerSecond * DeltaSeconds * (1.0f + FMath::Abs(ThrottleInput)));
    }

    if (bBrakePressed || bTrafficSignalStop || CurrentFuel <= 0.0f)
    {
        CurrentSpeed = FMath::FInterpConstantTo(CurrentSpeed, 0.0f, DeltaSeconds, BrakeDeceleration);
    }
    else
    {
        CurrentSpeed += ThrottleInput * Acceleration * DeltaSeconds;
        CurrentSpeed = FMath::Clamp(CurrentSpeed, -MaxForwardSpeed * 0.35f, MaxForwardSpeed);
        if (FMath::IsNearlyZero(ThrottleInput))
        {
            CurrentSpeed = FMath::FInterpConstantTo(CurrentSpeed, 0.0f, DeltaSeconds, 180.0f);
        }
    }

    const float SpeedRatio = FMath::Clamp(FMath::Abs(CurrentSpeed) / MaxForwardSpeed, 0.0f, 1.0f);
    if (SpeedRatio > 0.015f)
    {
        const float ReverseSign = CurrentSpeed >= 0.0f ? 1.0f : -1.0f;
        AddActorLocalRotation(FRotator(0.0f, SteeringInput * SteeringRate * SpeedRatio * ReverseSign * DeltaSeconds, 0.0f));
        const FVector MoveDelta(CurrentSpeed * DeltaSeconds, 0.0f, 0.0f);
        FHitResult Hit;
        AddActorLocalOffset(MoveDelta, true, &Hit);
        if (Hit.IsValidBlockingHit()) CurrentSpeed *= 0.25f;
    }

    UpdateWheelVisuals(DeltaSeconds);
}

void AVNHVehiclePawn::SetVehicleInput(float Throttle, float Steering)
{
    ThrottleInput = FMath::Clamp(Throttle, -1.0f, 1.0f);
    SteeringInput = FMath::Clamp(Steering, -1.0f, 1.0f);
}

void AVNHVehiclePawn::SetBrake(bool bPressed)
{
    bBrakePressed = bPressed;
}

void AVNHVehiclePawn::SetTrafficSignalStop(bool bShouldStop)
{
    bTrafficSignalStop = bShouldStop;
}

float AVNHVehiclePawn::Refuel(float Amount)
{
    if (Amount <= 0.0f || FuelCapacity <= 0.0f) return 0.0f;
    const float PreviousFuel = CurrentFuel;
    CurrentFuel = FMath::Clamp(CurrentFuel + Amount, 0.0f, FuelCapacity);
    return CurrentFuel - PreviousFuel;
}

void AVNHVehiclePawn::Interact_Implementation(AActor* InteractingActor)
{
    ACharacter* Character = Cast<ACharacter>(InteractingActor);
    if (!Character || !Character->GetController()) return;
    if (GetController() && !Cast<AAIController>(GetController())) return;

    PreviousCharacter = Character;
    Character->GetController()->Possess(this);
    CurrentSpeed = 0.0f;
    SetVehicleInput(0.0f, 0.0f);
}

void AVNHVehiclePawn::ExitVehicle()
{
    if (!PreviousCharacter) return;
    AController* DriverController = GetController();
    if (!DriverController) return;

    const FVector ExitLocation = GetActorLocation() - GetActorForwardVector() * 320.0f + GetActorRightVector() * 220.0f;
    const FRotator ExitRotation(0.0f, GetActorRotation().Yaw, 0.0f);
    FHitResult ExitHit;
    const bool bPlacedSafely = PreviousCharacter->SetActorLocation(ExitLocation, true, &ExitHit, ETeleportType::TeleportPhysics);
    if (!bPlacedSafely)
    {
        const FVector RearExit = GetActorLocation() - GetActorForwardVector() * 420.0f;
        PreviousCharacter->SetActorLocation(RearExit, false, nullptr, ETeleportType::TeleportPhysics);
    }
    PreviousCharacter->SetActorRotation(ExitRotation);
    DriverController->Possess(PreviousCharacter);
    PreviousCharacter = nullptr;
    SetVehicleInput(0.0f, 0.0f);
    SetBrake(false);
    CurrentSpeed = 0.0f;
    SpawnDefaultController();
}

void AVNHVehiclePawn::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
    Super::SetupPlayerInputComponent(PlayerInputComponent);
    check(PlayerInputComponent);
    PlayerInputComponent->BindAxis(TEXT("VehicleThrottle"), this, &AVNHVehiclePawn::ThrottleKeyboard);
    PlayerInputComponent->BindAxis(TEXT("VehicleSteer"), this, &AVNHVehiclePawn::SteerKeyboard);
    PlayerInputComponent->BindAction(TEXT("VehicleBrake"), IE_Pressed, this, &AVNHVehiclePawn::BrakePressed);
    PlayerInputComponent->BindAction(TEXT("VehicleBrake"), IE_Released, this, &AVNHVehiclePawn::BrakeReleased);
    PlayerInputComponent->BindAction(TEXT("ExitVehicle"), IE_Pressed, this, &AVNHVehiclePawn::ExitVehicleKeyboard);
}

void AVNHVehiclePawn::ThrottleKeyboard(float Value) { ThrottleInput = FMath::Clamp(Value, -1.0f, 1.0f); }
void AVNHVehiclePawn::SteerKeyboard(float Value) { SteeringInput = FMath::Clamp(Value, -1.0f, 1.0f); }
void AVNHVehiclePawn::BrakePressed() { SetBrake(true); }
void AVNHVehiclePawn::BrakeReleased() { SetBrake(false); }
void AVNHVehiclePawn::ExitVehicleKeyboard() { ExitVehicle(); }

void AVNHVehiclePawn::UpdateWheelVisuals(float DeltaSeconds)
{
    const float WheelDegrees = (CurrentSpeed * DeltaSeconds / 35.0f) * (180.0f / PI);
    for (UStaticMeshComponent* Wheel : WheelMeshes)
    {
        if (Wheel) Wheel->AddLocalRotation(FRotator(0.0f, WheelDegrees, 0.0f));
    }
}
