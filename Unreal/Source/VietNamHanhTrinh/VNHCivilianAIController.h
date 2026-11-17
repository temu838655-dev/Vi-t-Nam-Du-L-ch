#pragma once

#include "CoreMinimal.h"
#include "AIController.h"
#include "Navigation/PathFollowingComponent.h"
#include "VNHCivilianAIController.generated.h"

UCLASS()
class VIETNAMHANHTRINH_API AVNHCivilianAIController : public AAIController
{
    GENERATED_BODY()

public:
    virtual void OnPossess(APawn* InPawn) override;
    virtual void OnUnPossess() override;

protected:
    virtual void OnMoveCompleted(FAIRequestID RequestID, const FPathFollowingResult& Result) override;

private:
    int32 CurrentPatrolIndex = INDEX_NONE;
    FTimerHandle PatrolTimerHandle;

    void MoveToNextPatrolPoint();
    void ScheduleNextPatrolPoint();
};
