#include "VNHGameMode.h"
#include "VNHPlayerController.h"
#include "VNHPlayerCharacter.h"

AVNHGameMode::AVNHGameMode()
{
    PlayerControllerClass = AVNHPlayerController::StaticClass();
    DefaultPawnClass = AVNHPlayerCharacter::StaticClass();
}
