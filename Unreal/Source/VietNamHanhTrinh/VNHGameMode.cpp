#include "VNHGameMode.h"
#include "VNHPlayerController.h"

AVNHGameMode::AVNHGameMode()
{
    PlayerControllerClass = AVNHPlayerController::StaticClass();
}
