#pragma once
#include "CoreMinimal.h"
#include "GameFramework/SaveGame.h"
#include "VNHSaveGame.generated.h"

USTRUCT(BlueprintType)
struct FVNHSavedItem
{
    GENERATED_BODY()
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName ItemId = NAME_None;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) int32 Quantity = 0;
};

UCLASS(BlueprintType)
class VIETNAMHANHTRINH_API UVNHSaveGame : public USaveGame
{
    GENERATED_BODY()
public:
    static constexpr int32 CurrentSchemaVersion = 1;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Save") int32 SchemaVersion = CurrentSchemaVersion;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Player") FString PlayerId;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Player") int32 PlayerLevel = 1;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Economy") int64 Money = 0;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="World") FName CurrentRegionId = TEXT("HANOI_HOAN_KIEM");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="World") FName LastCheckpointId = NAME_None;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Progress") TArray<FName> CompletedMissionIds;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Inventory") TArray<FVNHSavedItem> Inventory;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Sync") int64 LocalRevision = 0;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Sync") FString LastLocalSaveUtc;
};
