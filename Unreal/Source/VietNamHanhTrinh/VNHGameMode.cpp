#include "VNHGameMode.h"

#include "VNHPlayerController.h"
#include "VNHPlayerCharacter.h"
#include "VNHSaveSubsystem.h"
#include "VNHHanoiPrototypeArea.h"
#include "Engine/World.h"
#include "Engine/GameInstance.h"
#include "EngineUtils.h"
#include "GameFramework/PlayerStart.h"
#include "TimerManager.h"

AVNHGameMode::AVNHGameMode()
{
    PlayerControllerClass = AVNHPlayerController::StaticClass();
    DefaultPawnClass = AVNHPlayerCharacter::StaticClass();
}

void AVNHGameMode::InitGame(const FString& MapName, const FString& Options, FString& ErrorMessage)
{
    Super::InitGame(MapName, Options, ErrorMessage);

    UWorld* World = GetWorld();
    if (!World) return;

    bool bHasHanoiBlockout = false;
    for (TActorIterator<AVNHHanoiPrototypeArea> It(World); It; ++It)
    {
        bHasHanoiBlockout = true;
        break;
    }

    if (!bHasHanoiBlockout)
    {
        World->SpawnActor<AVNHHanoiPrototypeArea>(AVNHHanoiPrototypeArea::StaticClass(),
            FVector::ZeroVector, FRotator::ZeroRotator);
    }

    bool bHasPlayerStart = false;
    for (TActorIterator<APlayerStart> It(World); It; ++It)
    {
        bHasPlayerStart = true;
        break;
    }

    if (!bHasPlayerStart)
    {
        World->SpawnActor<APlayerStart>(APlayerStart::StaticClass(),
            FVector(0.0f, -5800.0f, 100.0f), FRotator(0.0f, 90.0f, 0.0f));
    }
}

void AVNHGameMode::BeginPlay()
{
    Super::BeginPlay();

    if (WorldTimeUpdateIntervalSeconds <= 0.0f || GameMinutesPerUpdate <= 0)
    {
        return;
    }

    GetWorldTimerManager().SetTimer(
        WorldTimeTimerHandle,
        this,
        &AVNHGameMode::AdvanceWorldClock,
        WorldTimeUpdateIntervalSeconds,
        true);
}

void AVNHGameMode::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
    GetWorldTimerManager().ClearTimer(WorldTimeTimerHandle);
    Super::EndPlay(EndPlayReason);
}

void AVNHGameMode::AdvanceWorldClock()
{
    UGameInstance* GameInstance = GetGameInstance();
    if (!GameInstance) return;

    UVNHSaveSubsystem* SaveSubsystem = GameInstance->GetSubsystem<UVNHSaveSubsystem>();
    if (!SaveSubsystem || !SaveSubsystem->HasLocalSave()) return;

    SaveSubsystem->AdvanceGameMinutes(static_cast<int64>(GameMinutesPerUpdate));
}
