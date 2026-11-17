#pragma once

#include "CoreMinimal.h"
#include "GameFramework/PlayerController.h"
#include "VNHPlayerController.generated.h"

UCLASS()
class VIETNAMHANHTRINH_API AVNHPlayerController : public APlayerController
{
    GENERATED_BODY()

protected:
    virtual void BeginPlay() override;
};
