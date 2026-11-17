#include "VNHPlayerController.h"

void AVNHPlayerController::BeginPlay()
{
    Super::BeginPlay();

    // Mobile-first: touch is enabled and the desktop cursor stays hidden.
    bShowMouseCursor = false;
    bEnableClickEvents = true;
    bEnableTouchEvents = true;
    bEnableMouseOverEvents = false;

    FInputModeGameOnly InputMode;
    SetInputMode(InputMode);
}
