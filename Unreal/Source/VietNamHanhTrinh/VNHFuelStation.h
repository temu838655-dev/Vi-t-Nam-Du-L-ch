#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "VNHInteractable.h"
#include "VNHFuelStation.generated.h"

class UStaticMeshComponent;

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHFuelStation : public AActor, public IVNHInteractable
{
    GENERATED_BODY()

public:
    AVNHFuelStation();

    virtual void Interact_Implementation(AActor* InteractingActor) override;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Fuel")
    TObjectPtr<UStaticMeshComponent> PumpBody;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Fuel")
    TObjectPtr<UStaticMeshComponent> PumpDisplay;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="VNH|Fuel")
    float InteractionRadius = 500.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="VNH|Fuel")
    float FuelPerInteraction = 15.0f;

    UFUNCTION(BlueprintImplementableEvent, Category="VNH|Fuel")
    void OnFuelDispensed(AActor* Vehicle, float FuelAdded);
};
