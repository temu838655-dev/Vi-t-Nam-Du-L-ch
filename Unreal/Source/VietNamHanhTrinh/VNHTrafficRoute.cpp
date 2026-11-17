#include "VNHTrafficRoute.h"
#include "Components/SplineComponent.h"

AVNHTrafficRoute::AVNHTrafficRoute()
{
    PrimaryActorTick.bCanEverTick = false;
    RouteSpline = CreateDefaultSubobject<USplineComponent>(TEXT("RouteSpline"));
    SetRootComponent(RouteSpline);
    RouteSpline->SetClosedLoop(true);
}

float AVNHTrafficRoute::GetRouteLength() const
{
    return RouteSpline ? RouteSpline->GetSplineLength() : 0.0f;
}
