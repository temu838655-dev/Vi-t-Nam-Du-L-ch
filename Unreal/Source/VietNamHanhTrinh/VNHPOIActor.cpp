#include "VNHPOIActor.h"
#include "Components/StaticMeshComponent.h"
#include "UObject/ConstructorHelpers.h"

AVNHPOIActor::AVNHPOIActor()
{
    PrimaryActorTick.bCanEverTick = false;
    PlaceholderMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("PlaceholderMesh"));
    SetRootComponent(PlaceholderMesh);

    static ConstructorHelpers::FObjectFinder<UStaticMesh> CubeMesh(TEXT("/Engine/BasicShapes/Cube.Cube"));
    if (CubeMesh.Succeeded())
    {
        PlaceholderMesh->SetStaticMesh(CubeMesh.Object);
        PlaceholderMesh->SetRelativeScale3D(FVector(0.5f, 0.5f, 1.0f));
        PlaceholderMesh->SetCollisionProfileName(TEXT("BlockAll"));
    }

    DisplayName = FText::FromString(TEXT("Điểm tham quan"));
    Description = FText::FromString(TEXT("Thông tin địa điểm sẽ được cấu hình trong Blueprint."));
}

void AVNHPOIActor::Interact_Implementation(AActor* InteractingActor)
{
    OnPointOfInterestInteracted(InteractingActor);
}
