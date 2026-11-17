#include "VNHMotorbikePawn.h"
#include "Components/StaticMeshComponent.h"
#include "UObject/ConstructorHelpers.h"

AVNHMotorbikePawn::AVNHMotorbikePawn()
{
    MaxForwardSpeed = 1500.0f;
    Acceleration = 720.0f;
    BrakeDeceleration = 1900.0f;
    SteeringRate = 105.0f;

    if (VehicleBody)
    {
        VehicleBody->SetRelativeLocation(FVector(0.0f, 0.0f, 38.0f));
        VehicleBody->SetRelativeScale3D(FVector(1.25f, 0.20f, 0.18f));
    }

    for (int32 Index = 0; Index < WheelMeshes.Num(); ++Index)
    {
        UStaticMeshComponent* Wheel = WheelMeshes[Index];
        if (!Wheel) continue;

        const bool bKeepWheel = (Index == 0 || Index == 2);
        Wheel->SetVisibility(bKeepWheel, true);
        Wheel->SetHiddenInGame(!bKeepWheel, true);
        if (bKeepWheel)
        {
            const float X = Index == 0 ? 92.0f : -92.0f;
            Wheel->SetRelativeLocation(FVector(X, 0.0f, -18.0f));
            Wheel->SetRelativeScale3D(FVector(0.43f, 0.10f, 0.43f));
        }
    }

    static ConstructorHelpers::FObjectFinder<UStaticMesh> CubeMesh(TEXT("/Engine/BasicShapes/Cube.Cube"));
    static ConstructorHelpers::FObjectFinder<UStaticMesh> CylinderMesh(TEXT("/Engine/BasicShapes/Cylinder.Cylinder"));

    if (CubeMesh.Succeeded())
    {
        SeatMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("MotorbikeSeat"));
        SeatMesh->SetupAttachment(VehicleBody);
        SeatMesh->SetAbsolute(false, false, true);
        SeatMesh->SetStaticMesh(CubeMesh.Object);
        SeatMesh->SetRelativeLocation(FVector(-5.0f, 0.0f, 58.0f));
        SeatMesh->SetRelativeScale3D(FVector(0.48f, 0.27f, 0.10f));
        SeatMesh->SetCollisionEnabled(ECollisionEnabled::NoCollision);

        FuelTankMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("MotorbikeFuelTank"));
        FuelTankMesh->SetupAttachment(VehicleBody);
        FuelTankMesh->SetAbsolute(false, false, true);
        FuelTankMesh->SetStaticMesh(CubeMesh.Object);
        FuelTankMesh->SetRelativeLocation(FVector(34.0f, 0.0f, 54.0f));
        FuelTankMesh->SetRelativeScale3D(FVector(0.34f, 0.25f, 0.20f));
        FuelTankMesh->SetCollisionEnabled(ECollisionEnabled::NoCollision);

        HandlebarMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("MotorbikeHandlebar"));
        HandlebarMesh->SetupAttachment(VehicleBody);
        HandlebarMesh->SetAbsolute(false, false, true);
        HandlebarMesh->SetStaticMesh(CubeMesh.Object);
        HandlebarMesh->SetRelativeLocation(FVector(78.0f, 0.0f, 60.0f));
        HandlebarMesh->SetRelativeScale3D(FVector(0.10f, 0.48f, 0.06f));
        HandlebarMesh->SetCollisionEnabled(ECollisionEnabled::NoCollision);
    }

    if (CylinderMesh.Succeeded())
    {
        FrontForkMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("MotorbikeFrontFork"));
        FrontForkMesh->SetupAttachment(VehicleBody);
        FrontForkMesh->SetAbsolute(false, false, true);
        FrontForkMesh->SetStaticMesh(CylinderMesh.Object);
        FrontForkMesh->SetRelativeLocation(FVector(80.0f, 0.0f, 5.0f));
        FrontForkMesh->SetRelativeRotation(FRotator(0.0f, 0.0f, 12.0f));
        FrontForkMesh->SetRelativeScale3D(FVector(0.06f, 0.06f, 0.60f));
        FrontForkMesh->SetCollisionEnabled(ECollisionEnabled::NoCollision);
    }
}
