#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "VNHInteractable.h"
#include "VNHCivilianCharacter.generated.h"

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHCivilianCharacter : public ACharacter, public IVNHInteractable
{
    GENERATED_BODY()

public:
    AVNHCivilianCharacter();

    virtual void Interact_Implementation(AActor* InteractingActor) override;

    UFUNCTION(BlueprintImplementableEvent, Category="VNH|Civilian|Dialogue")
    void OnCivilianInteracted(AActor* InteractingActor);

    UPROPERTY(EditInstanceOnly, BlueprintReadOnly, Category="VNH|Civilian|Patrol")
    TArray<FVector> PatrolPoints;

    UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="VNH|Civilian")
    FText CivilianDisplayName;

    UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="VNH|Civilian")
    bool bCanBeTalkedTo = true;
};
