#include "VNHFuelStation.h"
#include "VNHVehiclePawn.h"
#include "Components/StaticMeshComponent.h"
#include "Engine/World.h"
#include "UObject/ConstructorHelpers.h"

AVNHFuelStation::AVNHFuelStation()
{
    PrimaryActorTick.bCanEverTick = false;

    PumpBody = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("PumpBody"));
    SetRootComponent(PumpBody);
    PumpBody->SetCollisionProfileName(TEXT("BlockAll"));

    PumpDisplay = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("PumpDisplay"));
    PumpDisplay->SetupAttachment(PumpBody);
    PumpDisplay->SetCollisionEnabled(ECollisionEnabled::NoCollision);

    static ConstructorHelpers::FObjectFinder<UStaticMesh> CubeMesh(TEXT("/Engine/BasicShapes/Cube.Cube"));
    if (CubeMesh.Succeeded())
    {
        PumpBody->SetStaticMesh(CubeMesh.Object);
        PumpBody->SetRelativeScale3D(FVector(0.45f, 0.38f, 0.85f));
        PumpDisplay->SetStaticMesh(CubeMesh.Object);
        PumpDisplay->SetRelativeLocation(FVector(0.0f, -39.0f, 42.0f));
        PumpDisplay->SetRelativeScale3D(FVector(0.28f, 0.04f, 0.20f));
    }
}

void AVNHFuelStation::Interact_Implementation(AActor* InteractingActor)
{
    if (!GetWorld()) return;

    TArray<FOverlapResult> Overlaps;
    FCollisionQueryParams QueryParams(SCENE_QUERY_STAT(VNHFuelStation), false, this);
    if (InteractingActor) QueryParams.AddIgnoredActor(InteractingActor);

    FCollisionObjectQueryParams ObjectTypes;
    ObjectTypes.AddObjectTypesToQuery(ECC_WorldDynamic);
    ObjectTypes.AddObjectTypesToQuery(ECC_Pawn);

    const bool bFound = GetWorld()->OverlapMultiByObjectType(
        Overlaps,
        GetActorLocation(),
        FQuat::Identity,
        ObjectTypes,
        FCollisionShape::MakeSphere(InteractionRadius),
        QueryParams);

    AVNHVehiclePawn* NearestVehicle = nullptr;
    float NearestDistanceSquared = TNumericLimits<float>::Max();

    if (bFound)
    {
        for (const FOverlapResult& Overlap : Overlaps)
        {
            AVNHVehiclePawn* Vehicle = Cast<AVNHVehiclePawn>(Overlap.GetActor());
            if (!Vehicle) continue;

            const float DistanceSquared = FVector::DistSquared(GetActorLocation(), Vehicle->GetActorLocation());
            if (DistanceSquared < NearestDistanceSquared)
            {
                NearestDistanceSquared = DistanceSquared;
                NearestVehicle = Vehicle;
            }
        }
    }

    if (NearestVehicle)
    {
        NearestVehicle->Refuel(FuelPerInteraction);
        OnFuelDispensed(NearestVehicle, FuelPerInteraction);
    }
}
