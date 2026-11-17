#pragma once

#include "CoreMinimal.h"
#include "GameFramework/GameModeBase.h"
#include "VNHGameMode.generated.h"

UCLASS()
class VIETNAMHANHTRINH_API AVNHGameMode : public AGameModeBase
{
    GENERATED_BODY()

public:
    AVNHGameMode();
    virtual void InitGame(const FString& MapName, const FString& Options, FString& ErrorMessage) override;
};
