#pragma once
#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "VNHHanoiPrototypeArea.generated.h"

UCLASS()
class VIETNAMHANHTRINH_API AVNHHanoiPrototypeArea : public AActor
{
    GENERATED_BODY()
public:
    AVNHHanoiPrototypeArea();
private:
    UPROPERTY()
    TObjectPtr<USceneComponent> SceneRoot;
};
