#include "VNHTrafficAIController.h"
#include "VNHVehiclePawn.h"
#include "VNHTrafficRoute.h"
#include "Components/SplineComponent.h"
#include "GameFramework/Pawn.h"
#include "Engine/World.h"

AVNHTrafficAIController::AVNHTrafficAIController()
{
    PrimaryActorTick.bCanEverTick = true;
}

void AVNHTrafficAIController::Tick(float DeltaSeconds)
{
    Super::Tick(DeltaSeconds);

    AVNHVehiclePawn* Vehicle = Cast<AVNHVehiclePawn>(GetPawn());
    if (!Vehicle) return;

    AVNHTrafficRoute* Route = Vehicle->GetTrafficRoute();
    if (!Route || !Route->RouteSpline || Route->GetRouteLength() < 100.0f)
    {
        Vehicle->SetVehicleInput(0.0f, 0.0f);
        Vehicle->SetBrake(true);
        return;
    }

    const float Length = Route->GetRouteLength();
    const float CurrentKey = Route->RouteSpline->FindInputKeyClosestToWorldLocation(Vehicle->GetActorLocation());
    const float CurrentDistance = Route->RouteSpline->GetDistanceAlongSplineAtSplineInputKey(CurrentKey);
    const float LookAheadDistance = FMath::Fmod(CurrentDistance + 650.0f, Length);
    const FVector Target = Route->RouteSpline->GetLocationAtDistanceAlongSpline(LookAheadDistance, ESplineCoordinateSpace::World);
    const FVector ToTarget = (Target - Vehicle->GetActorLocation()).GetSafeNormal2D();

    if (ToTarget.IsNearlyZero())
    {
        Vehicle->SetVehicleInput(0.0f, 0.0f);
        return;
    }

    const float DesiredYaw = ToTarget.Rotation().Yaw;
    const float YawError = FMath::FindDeltaAngleDegrees(Vehicle->GetActorRotation().Yaw, DesiredYaw);
    const float Steering = FMath::Clamp(YawError / 38.0f, -1.0f, 1.0f);
    const float TurnSlowdown = FMath::GetMappedRangeValueClamped(
        FVector2D(12.0f, 75.0f), FVector2D(1.0f, 0.42f), FMath::Abs(YawError));

    const FVector TraceStart = Vehicle->GetActorLocation() + Vehicle->GetActorForwardVector() * 300.0f + FVector(0.0f, 0.0f, 65.0f);
    const FVector TraceEnd = TraceStart + Vehicle->GetActorForwardVector() * 500.0f;
    FCollisionQueryParams QueryParams(SCENE_QUERY_STAT(VNHTrafficObstacleCheck), false, Vehicle);
    FHitResult ObstacleHit;
    const bool bObstacleAhead = GetWorld() && GetWorld()->LineTraceSingleByChannel(
        ObstacleHit, TraceStart, TraceEnd, ECC_Visibility, QueryParams);

    Vehicle->SetBrake(bObstacleAhead);
    Vehicle->SetVehicleInput(bObstacleAhead ? 0.0f : 0.62f * TurnSlowdown, Steering);
}
