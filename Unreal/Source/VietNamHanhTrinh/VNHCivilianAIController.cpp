#include "VNHCivilianAIController.h"
#include "VNHCivilianCharacter.h"
#include "Navigation/PathFollowingComponent.h"
#include "TimerManager.h"
#include "Engine/World.h"

void AVNHCivilianAIController::OnPossess(APawn* InPawn)
{
    Super::OnPossess(InPawn);
    CurrentPatrolIndex = INDEX_NONE;
    MoveToNextPatrolPoint();
}

void AVNHCivilianAIController::OnUnPossess()
{
    if (GetWorld()) GetWorld()->GetTimerManager().ClearTimer(PatrolTimerHandle);
    StopMovement();
    Super::OnUnPossess();
}

void AVNHCivilianAIController::MoveToNextPatrolPoint()
{
    AVNHCivilianCharacter* Civilian = Cast<AVNHCivilianCharacter>(GetPawn());
    if (!Civilian || Civilian->PatrolPoints.Num() == 0) return;

    CurrentPatrolIndex = (CurrentPatrolIndex + 1) % Civilian->PatrolPoints.Num();
    MoveToLocation(Civilian->PatrolPoints[CurrentPatrolIndex], 80.0f, true, true, true, false, nullptr, true);
}

void AVNHCivilianAIController::OnMoveCompleted(FAIRequestID RequestID, const FPathFollowingResult& Result)
{
    Super::OnMoveCompleted(RequestID, Result);
    ScheduleNextPatrolPoint();
}

void AVNHCivilianAIController::ScheduleNextPatrolPoint()
{
    if (!GetWorld()) return;
    const float WaitSeconds = FMath::FRandRange(1.0f, 3.0f);
    GetWorld()->GetTimerManager().SetTimer(
        PatrolTimerHandle,
        this,
        &AVNHCivilianAIController::MoveToNextPatrolPoint,
        WaitSeconds,
        false);
}
