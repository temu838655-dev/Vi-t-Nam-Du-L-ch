#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "VNHCivilianCharacter.generated.h"

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHCivilianCharacter : public ACharacter
{
    GENERATED_BODY()

public:
    AVNHCivilianCharacter();

    UPROPERTY(EditInstanceOnly, BlueprintReadOnly, Category="VNH|Civilian|Patrol")
    TArray<FVector> PatrolPoints;

    UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="VNH|Civilian")
    FText CivilianDisplayName;

    UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="VNH|Civilian")
    bool bCanBeTalkedTo = true;
};
