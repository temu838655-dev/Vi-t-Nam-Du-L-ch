#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "VNHTrafficRoute.generated.h"

class USplineComponent;

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHTrafficRoute : public AActor
{
    GENERATED_BODY()

public:
    AVNHTrafficRoute();

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|Traffic")
    TObjectPtr<USplineComponent> RouteSpline;

    UFUNCTION(BlueprintPure, Category="VNH|Traffic")
    float GetRouteLength() const;
};
