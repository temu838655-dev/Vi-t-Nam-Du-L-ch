#pragma once

#include "CoreMinimal.h"
#include "VNHVehiclePawn.h"
#include "VNHMotorbikePawn.generated.h"

class UStaticMeshComponent;

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHMotorbikePawn : public AVNHVehiclePawn
{
    GENERATED_BODY()

public:
    AVNHMotorbikePawn();

protected:
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Motorbike")
    TObjectPtr<UStaticMeshComponent> SeatMesh;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Motorbike")
    TObjectPtr<UStaticMeshComponent> FuelTankMesh;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Motorbike")
    TObjectPtr<UStaticMeshComponent> HandlebarMesh;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Motorbike")
    TObjectPtr<UStaticMeshComponent> FrontForkMesh;
};
