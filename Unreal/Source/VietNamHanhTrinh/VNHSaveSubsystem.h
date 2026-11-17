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
    UFUNCTION(BlueprintCallable, Category="VNH|Save") bool SaveProgress(UVNHSaveGame* SaveData);
    UFUNCTION(BlueprintCallable, Category="VNH|Save") UVNHSaveGame* LoadProgress();
    UFUNCTION(BlueprintPure, Category="VNH|Save") bool HasLocalSave() const;
    UFUNCTION(BlueprintCallable, Category="VNH|Save") bool DeleteLocalSave();
private:
    UPROPERTY() FString SaveSlotName = TEXT("VNH_PlayerProgress");
    UPROPERTY() int32 UserIndex = 0;
};
