#pragma once
#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "VNHSaveGame.h"
#include "VNHSaveSubsystem.generated.h"

UCLASS()
class VIETNAMHANHTRINH_API UVNHSaveSubsystem : public UGameInstanceSubsystem
{
    GENERATED_BODY()
public:
    UFUNCTION(BlueprintCallable, Category="VNH|Save")
    bool SaveProgress(UVNHSaveGame* SaveData);

    UFUNCTION(BlueprintCallable, Category="VNH|Save")
    UVNHSaveGame* LoadProgress();

    UFUNCTION(BlueprintPure, Category="VNH|Save")
    bool HasLocalSave() const;

    UFUNCTION(BlueprintCallable, Category="VNH|Save")
    bool DeleteLocalSave();

    // Call only after the player confirms "New Game". Existing progress is protected by default.
    UFUNCTION(BlueprintCallable, Category="VNH|Life")
    UVNHSaveGame* CreateNewLife(FString NewPlayerId, int64 StartingMoney, bool bReplaceExistingSave = false);

    UFUNCTION(BlueprintCallable, Category="VNH|Life")
    bool SelectCareer(FName JobId, FName WorkplaceId, int64 InMonthlySalary);

    UFUNCTION(BlueprintCallable, Category="VNH|Life")
    bool ClearCareerSelection();

    // Relationship changes are persisted and clamped to the 0-100 range.
    UFUNCTION(BlueprintCallable, Category="VNH|Life|Family")
    bool UpdateFamilyRelationship(FName CharacterId, int32 Delta);

    // Stores stable appearance preset IDs; visual assets are resolved separately by the character system.
    UFUNCTION(BlueprintCallable, Category="VNH|Life|Appearance")
    bool SetPlayerAppearance(const FVNHSavedAppearance& Appearance);

    // Replaces a family member schedule. Intervals must be valid and non-overlapping.
    UFUNCTION(BlueprintCallable, Category="VNH|Life|Family")
    bool SetFamilyDailyRoutine(FName CharacterId, const TArray<FVNHDailyRoutineEntry>& Routine);

    // Returns the activity/location active at the supplied in-game minute (0-1439).
    UFUNCTION(BlueprintCallable, Category="VNH|Life|Family")
    bool GetFamilyActivityAtTime(FName CharacterId, int32 MinuteOfDay, FName& OutActivityId, FName& OutLocationId);

    // Advances simulation time by a positive number of in-game minutes and persists it.
    UFUNCTION(BlueprintCallable, Category="VNH|World|Time")
    bool AdvanceGameMinutes(int64 MinutesToAdvance);

    // Reads the saved in-game calendar. WeekdayIndex: 0=Monday through 6=Sunday.
    UFUNCTION(BlueprintCallable, Category="VNH|World|Time")
    bool GetGameClock(int64& OutGameDay, int32& OutMinuteOfDay, int32& OutWeekdayIndex);

    UFUNCTION(BlueprintCallable, Category="VNH|Save")
    bool SaveCheckpoint(FName RegionId, FName CheckpointId);

    UFUNCTION(BlueprintCallable, Category="VNH|Economy")
    int64 GetMoney();

    UFUNCTION(BlueprintCallable, Category="VNH|Economy")
    bool TrySpendMoney(int64 Amount);

    UFUNCTION(BlueprintCallable, Category="VNH|Economy")
    bool AddMoney(int64 Amount);

private:
    UVNHSaveGame* LoadOrCreateProgress();
    bool MigrateSaveData(UVNHSaveGame* SaveData) const;

    UPROPERTY() FString SaveSlotName = TEXT("VNH_PlayerProgress");
    UPROPERTY() int32 UserIndex = 0;
};
