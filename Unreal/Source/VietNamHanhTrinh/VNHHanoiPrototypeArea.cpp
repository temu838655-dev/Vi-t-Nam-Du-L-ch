#include "VNHHanoiPrototypeArea.h"
#include "Components/SceneComponent.h"
#include "Components/StaticMeshComponent.h"
#include "UObject/ConstructorHelpers.h"

AVNHHanoiPrototypeArea::AVNHHanoiPrototypeArea()
{
    PrimaryActorTick.bCanEverTick = false;
    SceneRoot = CreateDefaultSubobject<USceneComponent>(TEXT("SceneRoot"));
    SetRootComponent(SceneRoot);

    // Greybox only: approximate layout, not surveyed GIS geometry.
    static ConstructorHelpers::FObjectFinder<UStaticMesh> CubeMesh(TEXT("/Engine/BasicShapes/Cube.Cube"));
    static ConstructorHelpers::FObjectFinder<UStaticMesh> CylinderMesh(TEXT("/Engine/BasicShapes/Cylinder.Cylinder"));
    if (!CubeMesh.Succeeded() || !CylinderMesh.Succeeded()) return;

    auto AddMesh = [this](const TCHAR* Name, UStaticMesh* MeshAsset, const FVector& Location, const FVector& Scale, bool bCollision)
    {
        UStaticMeshComponent* Component = CreateDefaultSubobject<UStaticMeshComponent>(FName(Name));
        Component->SetupAttachment(SceneRoot);
        Component->SetStaticMesh(MeshAsset);
        Component->SetRelativeLocation(Location);
        Component->SetRelativeScale3D(Scale);
        if (!bCollision) Component->SetCollisionEnabled(ECollisionEnabled::NoCollision);
    };

    // Flat cylinder suggests the lake footprint. Replace with authored shoreline and water.
    AddMesh(TEXT("HoanKiemLake_Blockout"), CylinderMesh.Object, FVector(0, 0, -8), FVector(8, 5, 0.035f), false);

    // Four surrounding road corridors.
    AddMesh(TEXT("NorthRoad"), CubeMesh.Object, FVector(0, 590, 0), FVector(15, 0.8f, 0.04f), true);
    AddMesh(TEXT("SouthRoad"), CubeMesh.Object, FVector(0, -590, 0), FVector(15, 0.8f, 0.04f), true);
    AddMesh(TEXT("EastRoad"), CubeMesh.Object, FVector(890, 0, 0), FVector(0.8f, 12, 0.04f), true);
    AddMesh(TEXT("WestRoad"), CubeMesh.Object, FVector(-890, 0, 0), FVector(0.8f, 12, 0.04f), true);

    // Simplified Turtle Tower massing, not a finished landmark model.
    AddMesh(TEXT("TurtleTower_Base"), CubeMesh.Object, FVector(0, 0, 25), FVector(0.65f, 0.65f, 0.25f), true);
    AddMesh(TEXT("TurtleTower_Shaft"), CubeMesh.Object, FVector(0, 0, 95), FVector(0.22f, 0.22f, 0.55f), true);
    AddMesh(TEXT("TurtleTower_Top"), CubeMesh.Object, FVector(0, 0, 205), FVector(0.42f, 0.42f, 0.12f), true);

    // Placeholder city blocks around the lake.
    AddMesh(TEXT("OldQuarter_Block_A"), CubeMesh.Object, FVector(1180, 720, 180), FVector(2.2f, 1.4f, 1.8f), true);
    AddMesh(TEXT("OldQuarter_Block_B"), CubeMesh.Object, FVector(-1180, 720, 240), FVector(1.8f, 1.4f, 2.4f), true);
    AddMesh(TEXT("OldQuarter_Block_C"), CubeMesh.Object, FVector(1180, -720, 140), FVector(2.5f, 1.6f, 1.4f), true);
    AddMesh(TEXT("OldQuarter_Block_D"), CubeMesh.Object, FVector(-1180, -720, 210), FVector(2.0f, 1.6f, 2.1f), true);
}
