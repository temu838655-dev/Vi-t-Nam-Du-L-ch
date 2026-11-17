#include "VNHFamilyHomePrototype.h"

#include "Components/SceneComponent.h"
#include "Components/StaticMeshComponent.h"
#include "UObject/ConstructorHelpers.h"

AVNHFamilyHomePrototype::AVNHFamilyHomePrototype()
{
    PrimaryActorTick.bCanEverTick = false;
    SceneRoot = CreateDefaultSubobject<USceneComponent>(TEXT("SceneRoot"));
    SetRootComponent(SceneRoot);

    static ConstructorHelpers::FObjectFinder<UStaticMesh> CubeMesh(TEXT("/Engine/BasicShapes/Cube.Cube"));
    if (!CubeMesh.Succeeded()) return;

    auto AddPart = [this](const TCHAR* Name, const FVector& Location, const FVector& Scale, bool bCollision)
    {
        UStaticMeshComponent* Part = CreateDefaultSubobject<UStaticMeshComponent>(FName(Name));
        Part->SetupAttachment(SceneRoot);
        Part->SetStaticMesh(CubeMesh.Object);
        Part->SetRelativeLocation(Location);
        Part->SetRelativeScale3D(Scale);
        Part->SetCollisionProfileName(bCollision ? TEXT("BlockAll") : TEXT("NoCollision"));
    };

    // Simple starter-home greybox, dimensions in centimetres. Front faces -Y.
    AddPart(TEXT("HouseFoundation"), FVector(0, 0, 12), FVector(10, 8, 0.24f), true);
    AddPart(TEXT("FrontWallLeft"), FVector(-2.9f * 100, -3.85f * 100, 150), FVector(4.2f, 0.3f, 3.0f), true);
    AddPart(TEXT("FrontWallRight"), FVector(2.9f * 100, -3.85f * 100, 150), FVector(4.2f, 0.3f, 3.0f), true);
    AddPart(TEXT("BackWall"), FVector(0, 3.85f * 100, 150), FVector(10, 0.3f, 3.0f), true);
    AddPart(TEXT("LeftWall"), FVector(-4.85f * 100, 0, 150), FVector(0.3f, 7.4f, 3.0f), true);
    AddPart(TEXT("RightWall"), FVector(4.85f * 100, 0, 150), FVector(0.3f, 7.4f, 3.0f), true);
    AddPart(TEXT("RoofMass"), FVector(0, 0, 335), FVector(10.8f, 8.8f, 0.5f), true);

    // Door and window markers are visual greybox pieces; they are not functional doors yet.
    AddPart(TEXT("FrontDoorMarker"), FVector(0, -4.02f * 100, 105), FVector(1.5f, 0.12f, 2.1f), false);
    AddPart(TEXT("FrontWindowLeft"), FVector(-2.8f * 100, -4.02f * 100, 215), FVector(1.4f, 0.12f, 0.9f), false);
    AddPart(TEXT("FrontWindowRight"), FVector(2.8f * 100, -4.02f * 100, 215), FVector(1.4f, 0.12f, 0.9f), false);

    // Small porch and steps lead toward the player start.
    AddPart(TEXT("FrontPorch"), FVector(0, -4.9f * 100, 15), FVector(3.0f, 1.8f, 0.3f), true);
}
