#include "VNHFuelStation.h"
#include "VNHVehiclePawn.h"
#include "VNHSaveSubsystem.h"
#include "Engine/GameInstance.h"
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

    const bool bFound = GetWorld()->OverlapMultiByChannel(
        Overlaps,
        GetActorLocation(),
        FQuat::Identity,
        ECC_Visibility,
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

    if (!NearestVehicle) return;

    UGameInstance* GameInstance = GetWorld() ? GetWorld()->GetGameInstance() : nullptr;
    UVNHSaveSubsystem* SaveSubsystem = GameInstance
        ? GameInstance->GetSubsystem<UVNHSaveSubsystem>()
        : nullptr;
    if (!SaveSubsystem || PricePerFuelUnit <= 0)
    {
        OnFuelPurchaseFailed();
        return;
    }

    const float RemainingCapacity = FMath::Max(0.0f, NearestVehicle->FuelCapacity - NearestVehicle->CurrentFuel);
    const float AffordableFuel = static_cast<float>(SaveSubsystem->GetMoney()) / static_cast<float>(PricePerFuelUnit);
    const float RequestedFuel = FMath::Min3(FuelPerInteraction, RemainingCapacity, AffordableFuel);
    if (RequestedFuel <= KINDA_SMALL_NUMBER)
    {
        OnFuelPurchaseFailed();
        return;
    }

    const int64 QuotedCost = FMath::CeilToInt64(RequestedFuel * static_cast<double>(PricePerFuelUnit));
    if (!SaveSubsystem->TrySpendMoney(QuotedCost))
    {
        OnFuelPurchaseFailed();
        return;
    }

    const float FuelAdded = NearestVehicle->Refuel(RequestedFuel);
    const int64 ActualCost = FMath::CeilToInt64(FuelAdded * static_cast<double>(PricePerFuelUnit));
    if (QuotedCost > ActualCost)
    {
        SaveSubsystem->AddMoney(QuotedCost - ActualCost);
    }

    if (FuelAdded > 0.0f)
    {
        OnFuelDispensed(NearestVehicle, FuelAdded, ActualCost);
    }
    else
    {
        SaveSubsystem->AddMoney(QuotedCost);
        OnFuelPurchaseFailed();
    }
}
