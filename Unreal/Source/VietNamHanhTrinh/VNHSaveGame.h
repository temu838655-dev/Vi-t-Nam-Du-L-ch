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
    static constexpr int32 CurrentSchemaVersion = 2;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Save") int32 SchemaVersion = CurrentSchemaVersion;

    // Player identity and progression
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Player") FString PlayerId;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Player") int32 PlayerLevel = 1;

    // Home and family are persistent life-simulation data, not respawn-only metadata.
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Home") FName HomeRegionId = TEXT("HANOI_HOAN_KIEM");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Home") FName HomeLocationId = TEXT("FAMILY_HOME_STARTER");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Family") FName MotherCharacterId = TEXT("FAMILY_MOTHER");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Family") FName FatherCharacterId = TEXT("FAMILY_FATHER");

    // Player chooses a career; NAME_None means the player has not selected one yet.
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Career") FName SelectedJobId = NAME_None;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Career") FName WorkplaceId = NAME_None;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Career") int64 MonthlySalary = 0;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Career") int32 CompletedWorkShifts = 0;

    // Spendable in-game balance; future UI can split cash and bank accounts.
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Economy") int64 Money = 0;

    // Current travel location is separate from the character's permanent home.
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="World") FName CurrentRegionId = TEXT("HANOI_HOAN_KIEM");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="World") FName LastCheckpointId = NAME_None;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Progress") TArray<FName> CompletedMissionIds;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Inventory") TArray<FVNHSavedItem> Inventory;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Sync") int64 LocalRevision = 0;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Sync") FString LastLocalSaveUtc;
};
