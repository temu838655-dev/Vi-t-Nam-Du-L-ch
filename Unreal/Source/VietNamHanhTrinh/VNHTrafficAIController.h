#pragma once

#include "CoreMinimal.h"
#include "AIController.h"
#include "VNHTrafficAIController.generated.h"

UCLASS()
class VIETNAMHANHTRINH_API AVNHTrafficAIController : public AAIController
{
    GENERATED_BODY()

public:
    AVNHTrafficAIController();
    virtual void Tick(float DeltaSeconds) override;

private:
    float RouteDistance = 0.0f;
};
