#include "VNHCivilianCharacter.h"
#include "VNHCivilianAIController.h"
#include "GameFramework/CharacterMovementComponent.h"

AVNHCivilianCharacter::AVNHCivilianCharacter()
{
    PrimaryActorTick.bCanEverTick = false;
    AIControllerClass = AVNHCivilianAIController::StaticClass();
    AutoPossessAI = EAutoPossessAI::PlacedInWorldOrSpawned;

    GetCharacterMovement()->MaxWalkSpeed = 180.0f;
    GetCharacterMovement()->bOrientRotationToMovement = true;
    GetCharacterMovement()->RotationRate = FRotator(0.0f, 360.0f, 0.0f);

    CivilianDisplayName = FText::FromString(TEXT("Người dân"));
}

void AVNHCivilianCharacter::Interact_Implementation(AActor* InteractingActor)
{
    if (bCanBeTalkedTo)
    {
        OnCivilianInteracted(InteractingActor);
    }
}
