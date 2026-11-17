#pragma once

#include "CoreMinimal.h"
#include "GameFramework/GameModeBase.h"
#include "TimerManager.h"
#include "VNHGameMode.generated.h"

UCLASS()
class VIETNAMHANHTRINH_API AVNHGameMode : public AGameModeBase
{
    GENERATED_BODY()

public:
    AVNHGameMode();
    virtual void InitGame(const FString& MapName, const FString& Options, FString& ErrorMessage) override;
    virtual void BeginPlay() override;
    virtual void EndPlay(const EEndPlayReason::Type EndPlayReason) override;

protected:
    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="VNH|World Time", meta=(ClampMin="1.0"))
    float WorldTimeUpdateIntervalSeconds = 5.0f;

    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="VNH|World Time", meta=(ClampMin="1"))
    int32 GameMinutesPerUpdate = 5;

private:
    FTimerHandle WorldTimeTimerHandle;
    void AdvanceWorldClock();
};
