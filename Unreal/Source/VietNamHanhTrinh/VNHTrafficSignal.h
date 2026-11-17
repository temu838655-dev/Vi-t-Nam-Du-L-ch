#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "VNHTrafficSignal.generated.h"

class UBoxComponent;
class UPointLightComponent;
class UPrimitiveComponent;
class AVNHVehiclePawn;

UENUM(BlueprintType)
enum class EVNHTrafficSignalState : uint8
{
    Green UMETA(DisplayName="Green"),
    Yellow UMETA(DisplayName="Yellow"),
    Red UMETA(DisplayName="Red")
};

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHTrafficSignal : public AActor
{
    GENERATED_BODY()

public:
    AVNHTrafficSignal();
    virtual void BeginPlay() override;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Traffic Signal")
    TObjectPtr<UBoxComponent> StopZone;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Traffic Signal")
    TObjectPtr<UPointLightComponent> RedLamp;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Traffic Signal")
    TObjectPtr<UPointLightComponent> YellowLamp;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Traffic Signal")
    TObjectPtr<UPointLightComponent> GreenLamp;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="VNH|Traffic Signal")
    float GreenDuration = 12.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="VNH|Traffic Signal")
    float YellowDuration = 3.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="VNH|Traffic Signal")
    float RedDuration = 12.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="VNH|Traffic Signal")
    EVNHTrafficSignalState InitialState = EVNHTrafficSignalState::Green;

    UFUNCTION(BlueprintPure, Category="VNH|Traffic Signal")
    EVNHTrafficSignalState GetSignalState() const { return CurrentState; }

protected:
    UFUNCTION()
    void OnStopZoneBeginOverlap(UPrimitiveComponent* OverlappedComponent, AActor* OtherActor,
        UPrimitiveComponent* OtherComponent, int32 OtherBodyIndex, bool bFromSweep,
        const FHitResult& SweepResult);

    UFUNCTION()
    void OnStopZoneEndOverlap(UPrimitiveComponent* OverlappedComponent, AActor* OtherActor,
        UPrimitiveComponent* OtherComponent, int32 OtherBodyIndex);

private:
    UPROPERTY(Transient)
    TArray<TObjectPtr<AVNHVehiclePawn>> VehiclesInZone;

    EVNHTrafficSignalState CurrentState = EVNHTrafficSignalState::Green;
    FTimerHandle StateTimerHandle;

    void SetSignalState(EVNHTrafficSignalState NewState);
    void AdvanceSignalState();
    void ScheduleNextState();
    void RefreshVehicleStops();
};
