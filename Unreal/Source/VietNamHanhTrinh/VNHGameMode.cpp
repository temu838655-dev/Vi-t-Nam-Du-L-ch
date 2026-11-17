#include "VNHGameMode.h"

#include "VNHPlayerController.h"
#include "VNHPlayerCharacter.h"
#include "VNHSaveSubsystem.h"
#include "VNHHanoiPrototypeArea.h"
#include "VNHFamilyHomePrototype.h"
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

    bool bHasFamilyHome = false;
    for (TActorIterator<AVNHFamilyHomePrototype> It(World); It; ++It)
    {
        bHasFamilyHome = true;
        break;
    }

    const FVector FamilyHomeLocation(14500.0f, 0.0f, 0.0f);
    if (!bHasFamilyHome)
    {
        World->SpawnActor<AVNHFamilyHomePrototype>(
            AVNHFamilyHomePrototype::StaticClass(),
            FamilyHomeLocation,
            FRotator::ZeroRotator);
    }

    bool bHasPlayerStart = false;
    for (TActorIterator<APlayerStart> It(World); It; ++It)
    {
        bHasPlayerStart = true;
        break;
    }

    if (!bHasPlayerStart)
    {
        // New players begin outside the starter family home, not at a respawn checkpoint.
        World->SpawnActor<APlayerStart>(APlayerStart::StaticClass(),
            FVector(14500.0f, -1000.0f, 100.0f), FRotator(0.0f, 90.0f, 0.0f));
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
