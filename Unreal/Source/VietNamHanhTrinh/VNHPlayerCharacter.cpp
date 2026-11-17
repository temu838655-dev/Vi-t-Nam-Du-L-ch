#include "VNHPlayerCharacter.h"
#include "Camera/CameraComponent.h"
#include "GameFramework/CharacterMovementComponent.h"
#include "GameFramework/SpringArmComponent.h"
#include "GameFramework/Controller.h"
#include "Components/InputComponent.h"
#include "VNHInteractable.h"
#include "Engine/World.h"

AVNHPlayerCharacter::AVNHPlayerCharacter()
{
    PrimaryActorTick.bCanEverTick = true;
    bUseControllerRotationPitch = false;
    bUseControllerRotationRoll = false;
    bUseControllerRotationYaw = false;
    GetCapsuleComponent()->InitCapsuleSize(42.0f, 92.0f);
    UCharacterMovementComponent* Movement = GetCharacterMovement();
    Movement->bOrientRotationToMovement = true;
    Movement->RotationRate = FRotator(0.0f, 540.0f, 0.0f);
    Movement->MaxWalkSpeed = WalkSpeed;
    Movement->JumpZVelocity = 420.0f;
    Movement->AirControl = 0.25f;
    Movement->BrakingDecelerationWalking = 1800.0f;
    CameraBoom = CreateDefaultSubobject<USpringArmComponent>(TEXT("CameraBoom"));
    CameraBoom->SetupAttachment(RootComponent);
    CameraBoom->TargetArmLength = 360.0f;
    CameraBoom->SetRelativeLocation(FVector(0.0f, 0.0f, 70.0f));
    CameraBoom->bUsePawnControlRotation = true;
    CameraBoom->bEnableCameraLag = true;
    CameraBoom->CameraLagSpeed = 12.0f;
    CameraBoom->bDoCollisionTest = true;
    PlayerCamera = CreateDefaultSubobject<UCameraComponent>(TEXT("PlayerCamera"));
    PlayerCamera->SetupAttachment(CameraBoom, USpringArmComponent::SocketName);
    PlayerCamera->bUsePawnControlRotation = false;
}

void AVNHPlayerCharacter::Tick(float DeltaSeconds)
{
    Super::Tick(DeltaSeconds);
    if (!Controller) return;
    const FRotator YawOnly(0.0f, Controller->GetControlRotation().Yaw, 0.0f);
    AddMovementInput(FRotationMatrix(YawOnly).GetUnitAxis(EAxis::X), MoveForwardInput);
    AddMovementInput(FRotationMatrix(YawOnly).GetUnitAxis(EAxis::Y), MoveRightInput);
}

void AVNHPlayerCharacter::SetMoveInput(float Forward, float Right)
{
    MoveForwardInput = FMath::Clamp(Forward, -1.0f, 1.0f);
    MoveRightInput = FMath::Clamp(Right, -1.0f, 1.0f);
}

void AVNHPlayerCharacter::AddLookInput(float DeltaX, float DeltaY)
{
    if (!Controller) return;
    AddControllerYawInput(DeltaX * TouchLookSensitivity);
    AddControllerPitchInput(-DeltaY * TouchLookSensitivity);
}

void AVNHPlayerCharacter::SetSprinting(bool bNewSprinting)
{
    GetCharacterMovement()->MaxWalkSpeed = bNewSprinting ? SprintSpeed : WalkSpeed;
}
void AVNHPlayerCharacter::TriggerJump() { Jump(); }
void AVNHPlayerCharacter::StopJump() { StopJumping(); }

void AVNHPlayerCharacter::TryInteract()
{
    if (!PlayerCamera || !GetWorld()) return;
    const FVector Start = PlayerCamera->GetComponentLocation();
    const FVector End = Start + PlayerCamera->GetForwardVector() * InteractionDistance;
    FHitResult Hit;
    FCollisionQueryParams Params(FName(TEXT("VNHInteraction")), false, this);
    if (GetWorld()->LineTraceSingleByChannel(Hit, Start, End, ECC_Visibility, Params))
    {
        AActor* Target = Hit.GetActor();
        if (Target && Target->GetClass()->ImplementsInterface(UVNHInteractable::StaticClass()))
        {
            IVNHInteractable::Execute_Interact(Target, this);
        }
    }
}

void AVNHPlayerCharacter::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
    Super::SetupPlayerInputComponent(PlayerInputComponent);
    check(PlayerInputComponent);
    PlayerInputComponent->BindAxis(TEXT("MoveForward"), this, &AVNHPlayerCharacter::MoveForwardKeyboard);
    PlayerInputComponent->BindAxis(TEXT("MoveRight"), this, &AVNHPlayerCharacter::MoveRightKeyboard);
    PlayerInputComponent->BindAxis(TEXT("Turn"), this, &AVNHPlayerCharacter::TurnKeyboard);
    PlayerInputComponent->BindAxis(TEXT("LookUp"), this, &AVNHPlayerCharacter::LookUpKeyboard);
    PlayerInputComponent->BindAction(TEXT("Jump"), IE_Pressed, this, &AVNHPlayerCharacter::StartKeyboardJump);
    PlayerInputComponent->BindAction(TEXT("Jump"), IE_Released, this, &AVNHPlayerCharacter::StopKeyboardJump);
    PlayerInputComponent->BindAction(TEXT("Interact"), IE_Pressed, this, &AVNHPlayerCharacter::TryInteract);
}

void AVNHPlayerCharacter::MoveForwardKeyboard(float Value) { MoveForwardInput = FMath::Clamp(Value, -1.0f, 1.0f); }
void AVNHPlayerCharacter::MoveRightKeyboard(float Value) { MoveRightInput = FMath::Clamp(Value, -1.0f, 1.0f); }
void AVNHPlayerCharacter::TurnKeyboard(float Value) { AddLookInput(Value * 8.0f, 0.0f); }
void AVNHPlayerCharacter::LookUpKeyboard(float Value) { AddLookInput(0.0f, -Value * 8.0f); }
void AVNHPlayerCharacter::StartKeyboardJump() { TriggerJump(); }
void AVNHPlayerCharacter::StopKeyboardJump() { StopJump(); }
