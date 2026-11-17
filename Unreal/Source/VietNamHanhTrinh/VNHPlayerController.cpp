#include "VNHPlayerController.h"

void AVNHPlayerController::BeginPlay()
{
    Super::BeginPlay();

    bShowMouseCursor = true;
    bEnableClickEvents = true;
    bEnableTouchEvents = true;
}
