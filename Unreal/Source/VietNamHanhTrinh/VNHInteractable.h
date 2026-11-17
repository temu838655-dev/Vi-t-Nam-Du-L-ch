#pragma once
#include "CoreMinimal.h"
#include "UObject/Interface.h"
#include "VNHInteractable.generated.h"

UINTERFACE(BlueprintType)
class VIETNAMHANHTRINH_API UVNHInteractable : public UInterface
{
    GENERATED_BODY()
};

class VIETNAMHANHTRINH_API IVNHInteractable
{
    GENERATED_BODY()
public:
    UFUNCTION(BlueprintNativeEvent, BlueprintCallable, Category="VNH|Interaction")
    void Interact(AActor* InteractingActor);
};
