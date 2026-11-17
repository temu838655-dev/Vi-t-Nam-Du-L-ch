#pragma once

#include "CoreMinimal.h"
#include "GameFramework/PlayerController.h"
#include "VNHPlayerController.generated.h"

class UUserWidget;

UCLASS()
class VIETNAMHANHTRINH_API AVNHPlayerController : public APlayerController
{
    GENERATED_BODY()

protected:
    virtual void BeginPlay() override;

private:
    UPROPERTY(Transient)
    TObjectPtr<UUserWidget> MobileHUDInstance;
};
