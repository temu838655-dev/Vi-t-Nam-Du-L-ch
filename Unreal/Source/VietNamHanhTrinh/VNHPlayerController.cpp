#include "VNHPlayerController.h"
#include "Blueprint/UserWidget.h"

void AVNHPlayerController::BeginPlay()
{
    Super::BeginPlay();

    bShowMouseCursor = false;
    bEnableClickEvents = true;
    bEnableTouchEvents = true;
    bEnableMouseOverEvents = false;

    if (IsLocalController() && MobileHUDClass)
    {
        MobileHUDInstance = CreateWidget<UUserWidget>(this, MobileHUDClass);
        if (MobileHUDInstance)
        {
            MobileHUDInstance->AddToViewport(0);
            FInputModeGameAndUI InputMode;
            InputMode.SetHideCursorDuringCapture(true);
            SetInputMode(InputMode);
            return;
        }
    }

    FInputModeGameOnly InputMode;
    SetInputMode(InputMode);
}
