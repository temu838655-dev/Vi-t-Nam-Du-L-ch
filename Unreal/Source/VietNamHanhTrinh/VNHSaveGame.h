#pragma once

#include "CoreMinimal.h"
#include "GameFramework/SaveGame.h"
#include "VNHSaveGame.generated.h"

UCLASS()
class VIETNAMHANHTRINH_API UVNHSaveGame : public USaveGame
{
    GENERATED_BODY()

public:
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, Category="Progress")
    FString PlayerId;

    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, Category="Progress")
    int32 PlayerLevel = 1;

    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, Category="Progress")
    int64 Money = 0;

    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, Category="Progress")
    FString LastVisitedRegionId;

    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, Category="Progress")
    TArray<FString> InventoryItemIds;

    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, Category="Progress")
    int32 SaveSchemaVersion = 1;
};
