#include "VNHPlayerCharacter.h"
#include "Camera/CameraComponent.h"
#include "GameFramework/CharacterMovementComponent.h"
#include "GameFramework/SpringArmComponent.h"
#include "GameFramework/Controller.h"

AVNHPlayerCharacter::AVNHPlayerCharacter()
{
    PrimaryActorTick.bCanEverTick = false;
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

void AVNHPlayerCharacter::SetMoveInput(float Forward, float Right)
{
    if (!Controller) return;
    const float F = FMath::Clamp(Forward, -1.0f, 1.0f);
    const float R = FMath::Clamp(Right, -1.0f, 1.0f);
    const FRotator YawOnly(0.0f, Controller->GetControlRotation().Yaw, 0.0f);
    AddMovementInput(FRotationMatrix(YawOnly).GetUnitAxis(EAxis::X), F);
    AddMovementInput(FRotationMatrix(YawOnly).GetUnitAxis(EAxis::Y), R);
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
