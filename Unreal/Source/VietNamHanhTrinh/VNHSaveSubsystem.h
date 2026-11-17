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
