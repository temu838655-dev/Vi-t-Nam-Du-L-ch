#include "VNHPointOfInterest.h"
#include "Components/StaticMeshComponent.h"

AVNHPointOfInterest::AVNHPointOfInterest()
{
    PrimaryActorTick.bCanEverTick = false;
    Visual = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Visual"));
    SetRootComponent(Visual);
    Visual->SetCollisionProfileName(TEXT("BlockAll"));
}

void AVNHPointOfInterest::Interact_Implementation(AActor* InteractingActor)
{
    OnPointOfInterestInteracted(InteractingActor);
}
