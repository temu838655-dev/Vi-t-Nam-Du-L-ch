#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "VNHFamilyHomePrototype.generated.h"

class USceneComponent;

UCLASS()
class VIETNAMHANHTRINH_API AVNHFamilyHomePrototype : public AActor
{
    GENERATED_BODY()

public:
    AVNHFamilyHomePrototype();

private:
    UPROPERTY()
    TObjectPtr<USceneComponent> SceneRoot;
};
