#include "VNHTrafficSignal.h"
#include "VNHVehiclePawn.h"
#include "Components/BoxComponent.h"
#include "Components/PointLightComponent.h"
#include "Engine/World.h"
#include "TimerManager.h"

AVNHTrafficSignal::AVNHTrafficSignal()
{
    PrimaryActorTick.bCanEverTick = false;

    StopZone = CreateDefaultSubobject<UBoxComponent>(TEXT("StopZone"));
    SetRootComponent(StopZone);
    StopZone->SetBoxExtent(FVector(650.0f, 350.0f, 180.0f));
    StopZone->SetCollisionEnabled(ECollisionEnabled::QueryOnly);
    StopZone->SetCollisionObjectType(ECC_WorldDynamic);
    StopZone->SetCollisionResponseToAllChannels(ECR_Ignore);
    StopZone->SetCollisionResponseToChannel(ECC_WorldDynamic, ECR_Overlap);
    StopZone->SetGenerateOverlapEvents(true);

    RedLamp = CreateDefaultSubobject<UPointLightComponent>(TEXT("RedLamp"));
    RedLamp->SetupAttachment(StopZone);
    RedLamp->SetRelativeLocation(FVector(0.0f, 0.0f, 100.0f));
    RedLamp->SetLightColor(FLinearColor(1.0f, 0.02f, 0.01f));
    RedLamp->SetIntensity(3000.0f);

    YellowLamp = CreateDefaultSubobject<UPointLightComponent>(TEXT("YellowLamp"));
    YellowLamp->SetupAttachment(StopZone);
    YellowLamp->SetRelativeLocation(FVector(0.0f, 0.0f, 0.0f));
    YellowLamp->SetLightColor(FLinearColor(1.0f, 0.55f, 0.01f));
    YellowLamp->SetIntensity(0.0f);

    GreenLamp = CreateDefaultSubobject<UPointLightComponent>(TEXT("GreenLamp"));
    GreenLamp->SetupAttachment(StopZone);
    GreenLamp->SetRelativeLocation(FVector(0.0f, 0.0f, -100.0f));
    GreenLamp->SetLightColor(FLinearColor(0.02f, 1.0f, 0.08f));
    GreenLamp->SetIntensity(0.0f);

    StopZone->OnComponentBeginOverlap.AddDynamic(this, &AVNHTrafficSignal::OnStopZoneBeginOverlap);
    StopZone->OnComponentEndOverlap.AddDynamic(this, &AVNHTrafficSignal::OnStopZoneEndOverlap);
}

void AVNHTrafficSignal::BeginPlay()
{
    Super::BeginPlay();
    SetSignalState(InitialState);
    ScheduleNextState();
}

void AVNHTrafficSignal::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
    if (GetWorld())
    {
        GetWorld()->GetTimerManager().ClearTimer(StateTimerHandle);
    }
    for (AVNHVehiclePawn* Vehicle : VehiclesInZone)
    {
        if (IsValid(Vehicle)) Vehicle->RemoveTrafficSignalStopSource(this);
    }
    VehiclesInZone.Reset();
    Super::EndPlay(EndPlayReason);
}

void AVNHTrafficSignal::SetSignalState(EVNHTrafficSignalState NewState)
{
    CurrentState = NewState;
    RedLamp->SetIntensity(CurrentState == EVNHTrafficSignalState::Red ? 3000.0f : 0.0f);
    YellowLamp->SetIntensity(CurrentState == EVNHTrafficSignalState::Yellow ? 3000.0f : 0.0f);
    GreenLamp->SetIntensity(CurrentState == EVNHTrafficSignalState::Green ? 3000.0f : 0.0f);
    RefreshVehicleStops();
}

void AVNHTrafficSignal::AdvanceSignalState()
{
    switch (CurrentState)
    {
        case EVNHTrafficSignalState::Green:
            SetSignalState(EVNHTrafficSignalState::Yellow);
            break;
        case EVNHTrafficSignalState::Yellow:
            SetSignalState(EVNHTrafficSignalState::Red);
            break;
        default:
            SetSignalState(EVNHTrafficSignalState::Green);
            break;
    }
    ScheduleNextState();
}

void AVNHTrafficSignal::ScheduleNextState()
{
    if (!GetWorld()) return;
    float Duration = GreenDuration;
    if (CurrentState == EVNHTrafficSignalState::Yellow) Duration = YellowDuration;
    else if (CurrentState == EVNHTrafficSignalState::Red) Duration = RedDuration;
    GetWorld()->GetTimerManager().SetTimer(
        StateTimerHandle, this, &AVNHTrafficSignal::AdvanceSignalState, FMath::Max(0.5f, Duration), false);
}

void AVNHTrafficSignal::OnStopZoneBeginOverlap(UPrimitiveComponent* OverlappedComponent, AActor* OtherActor,
    UPrimitiveComponent* OtherComponent, int32 OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult)
{
    AVNHVehiclePawn* Vehicle = Cast<AVNHVehiclePawn>(OtherActor);
    if (!Vehicle) return;
    VehiclesInZone.AddUnique(Vehicle);
    if (CurrentState == EVNHTrafficSignalState::Green) Vehicle->RemoveTrafficSignalStopSource(this);
    else Vehicle->AddTrafficSignalStopSource(this);
}

void AVNHTrafficSignal::OnStopZoneEndOverlap(UPrimitiveComponent* OverlappedComponent, AActor* OtherActor,
    UPrimitiveComponent* OtherComponent, int32 OtherBodyIndex)
{
    AVNHVehiclePawn* Vehicle = Cast<AVNHVehiclePawn>(OtherActor);
    if (!Vehicle) return;
    Vehicle->RemoveTrafficSignalStopSource(this);
    VehiclesInZone.Remove(Vehicle);
}

void AVNHTrafficSignal::RefreshVehicleStops()
{
    for (int32 Index = VehiclesInZone.Num() - 1; Index >= 0; --Index)
    {
        AVNHVehiclePawn* Vehicle = VehiclesInZone[Index];
        if (!IsValid(Vehicle))
        {
            VehiclesInZone.RemoveAt(Index);
            continue;
        }
        Vehicle->SetTrafficSignalStop(CurrentState != EVNHTrafficSignalState::Green);
    }
}
