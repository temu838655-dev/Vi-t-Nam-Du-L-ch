#include "VNHHanoiPrototypeArea.h"
#include "Components/SceneComponent.h"
#include "Components/StaticMeshComponent.h"
#include "UObject/ConstructorHelpers.h"

AVNHHanoiPrototypeArea::AVNHHanoiPrototypeArea()
{
    PrimaryActorTick.bCanEverTick = false;
    SceneRoot = CreateDefaultSubobject<USceneComponent>(TEXT("SceneRoot"));
    SetRootComponent(SceneRoot);

    // Centimetres. This is a gameplay greybox, not surveyed GIS geometry.
    static ConstructorHelpers::FObjectFinder<UStaticMesh> CubeMesh(TEXT("/Engine/BasicShapes/Cube.Cube"));
    static ConstructorHelpers::FObjectFinder<UStaticMesh> CylinderMesh(TEXT("/Engine/BasicShapes/Cylinder.Cylinder"));
    if (!CubeMesh.Succeeded() || !CylinderMesh.Succeeded()) return;

    auto AddMesh = [this](const TCHAR* Name, UStaticMesh* Asset, const FVector& Location, const FVector& Scale, bool bCollision)
    {
        UStaticMeshComponent* Component = CreateDefaultSubobject<UStaticMeshComponent>(FName(Name));
        Component->SetupAttachment(SceneRoot);
        Component->SetStaticMesh(Asset);
        Component->SetRelativeLocation(Location);
        Component->SetRelativeScale3D(Scale);
        Component->SetCollisionProfileName(bCollision ? TEXT("BlockAll") : TEXT("NoCollision"));
    };

    // Base terrain: 400 m x 320 m. Top surface is approximately Z=-2 cm.
    AddMesh(TEXT("PrototypeGround"), CubeMesh.Object, FVector(0, 0, -52), FVector(200, 160, 0.5f), true);

    // Lake footprint: approximately 160 m x 100 m. Water is only a visual placeholder.
    AddMesh(TEXT("HoanKiemLake_Blockout"), CylinderMesh.Object, FVector(0, 0, -8), FVector(80, 50, 0.035f), false);

    // Roads around the lake, with long blocks to make the scale readable.
    AddMesh(TEXT("NorthRoad"), CubeMesh.Object, FVector(0, 7200, 0), FVector(150, 8, 0.04f), true);
    AddMesh(TEXT("SouthRoad"), CubeMesh.Object, FVector(0, -7200, 0), FVector(150, 8, 0.04f), true);
    AddMesh(TEXT("EastRoad"), CubeMesh.Object, FVector(8900, 0, 0), FVector(8, 120, 0.04f), true);
    AddMesh(TEXT("WestRoad"), CubeMesh.Object, FVector(-8900, 0, 0), FVector(8, 120, 0.04f), true);

    // Simplified Turtle Tower massing, not a finished landmark.
    AddMesh(TEXT("TurtleTower_Base"), CubeMesh.Object, FVector(0, 0, 75), FVector(6.5f, 6.5f, 1.5f), true);
    AddMesh(TEXT("TurtleTower_Shaft"), CubeMesh.Object, FVector(0, 0, 450), FVector(2.2f, 2.2f, 6.0f), true);
    AddMesh(TEXT("TurtleTower_Top"), CubeMesh.Object, FVector(0, 0, 800), FVector(4.0f, 4.0f, 1.0f), true);

    // Simplified Ngoc Son temple and The Huc bridge placeholders.
    AddMesh(TEXT("TheHucBridge_Deck"), CubeMesh.Object, FVector(0, 3900, 25), FVector(2.5f, 18.0f, 0.15f), true);
    AddMesh(TEXT("NgocSonTemple_MainHall"), CubeMesh.Object, FVector(0, 5700, 180), FVector(12.0f, 8.0f, 3.6f), true);
    AddMesh(TEXT("NgocSonTemple_RoofMass"), CubeMesh.Object, FVector(0, 5700, 560), FVector(14.0f, 9.0f, 0.8f), true);

    // Larger placeholder blocks representing surrounding Old Quarter buildings.
    AddMesh(TEXT("OldQuarter_Block_A"), CubeMesh.Object, FVector(11800, 7200, 900), FVector(12, 8, 9), true);
    AddMesh(TEXT("OldQuarter_Block_B"), CubeMesh.Object, FVector(-11800, 7200, 1200), FVector(10, 8, 12), true);
    AddMesh(TEXT("OldQuarter_Block_C"), CubeMesh.Object, FVector(11800, -7200, 700), FVector(14, 9, 7), true);
    AddMesh(TEXT("OldQuarter_Block_D"), CubeMesh.Object, FVector(-11800, -7200, 1050), FVector(11, 9, 10.5f), true);

    // Sidewalk-like strips around the main road loop.
    AddMesh(TEXT("NorthSidewalk"), CubeMesh.Object, FVector(0, 6500, 12), FVector(150, 2.0f, 0.12f), true);
    AddMesh(TEXT("SouthSidewalk"), CubeMesh.Object, FVector(0, -6500, 12), FVector(150, 2.0f, 0.12f), true);
    AddMesh(TEXT("EastSidewalk"), CubeMesh.Object, FVector(9500, 0, 12), FVector(2.0f, 120, 0.12f), true);
    AddMesh(TEXT("WestSidewalk"), CubeMesh.Object, FVector(-9500, 0, 12), FVector(2.0f, 120, 0.12f), true);
}
