#include "VNHSaveSubsystem.h"
#include "Kismet/GameplayStatics.h"
#include "Misc/DateTime.h"

bool UVNHSaveSubsystem::SaveProgress(UVNHSaveGame* SaveData)
{
    if (!IsValid(SaveData) || SaveData->SchemaVersion > UVNHSaveGame::CurrentSchemaVersion)
    {
        return false;
    }

    SaveData->SchemaVersion = UVNHSaveGame::CurrentSchemaVersion;
    SaveData->LocalRevision = FMath::Max<int64>(0, SaveData->LocalRevision) + 1;
    SaveData->LastLocalSaveUtc = FDateTime::UtcNow().ToIso8601();
    return UGameplayStatics::SaveGameToSlot(SaveData, SaveSlotName, UserIndex);
}

bool UVNHSaveSubsystem::MigrateSaveData(UVNHSaveGame* SaveData) const
{
    if (!IsValid(SaveData) || SaveData->SchemaVersion <= 0 ||
        SaveData->SchemaVersion > UVNHSaveGame::CurrentSchemaVersion)
    {
        return false;
    }

    // Version 1 had travel/economy/progression data only. Add safe life-simulation
    // defaults without changing the player's saved travel location or balance.
    if (SaveData->SchemaVersion < 2)
    {
        if (SaveData->HomeRegionId.IsNone())
        {
            SaveData->HomeRegionId = TEXT("HANOI_HOAN_KIEM");
        }
        if (SaveData->HomeLocationId.IsNone())
        {
            SaveData->HomeLocationId = TEXT("FAMILY_HOME_STARTER");
        }
        if (SaveData->MotherCharacterId.IsNone())
        {
            SaveData->MotherCharacterId = TEXT("FAMILY_MOTHER");
        }
        if (SaveData->FatherCharacterId.IsNone())
        {
            SaveData->FatherCharacterId = TEXT("FAMILY_FATHER");
        }
        // NAME_None for SelectedJobId is intentional: never assign a career for the player.
        SaveData->SchemaVersion = 2;
    }

    return SaveData->SchemaVersion == UVNHSaveGame::CurrentSchemaVersion;
}

UVNHSaveGame* UVNHSaveSubsystem::LoadProgress()
{
    if (!HasLocalSave())
    {
        return nullptr;
    }

    UVNHSaveGame* LoadedSave = Cast<UVNHSaveGame>(
        UGameplayStatics::LoadGameFromSlot(SaveSlotName, UserIndex));

    if (!IsValid(LoadedSave))
    {
        return nullptr;
    }

    const int32 LoadedSchemaVersion = LoadedSave->SchemaVersion;
    if (!MigrateSaveData(LoadedSave))
    {
        return nullptr;
    }

    // Persist only when a migration actually changed the schema. A normal load
    // must not increment LocalRevision or rewrite the save slot.
    if (LoadedSchemaVersion != LoadedSave->SchemaVersion && !SaveProgress(LoadedSave))
    {
        return nullptr;
    }

    return LoadedSave;
}

bool UVNHSaveSubsystem::HasLocalSave() const
{
    return UGameplayStatics::DoesSaveGameExist(SaveSlotName, UserIndex);
}

bool UVNHSaveSubsystem::DeleteLocalSave()
{
    return !HasLocalSave() || UGameplayStatics::DeleteGameInSlot(SaveSlotName, UserIndex);
}

UVNHSaveGame* UVNHSaveSubsystem::CreateNewLife(
    FString NewPlayerId, int64 StartingMoney, bool bReplaceExistingSave)
{
    if (HasLocalSave() && !bReplaceExistingSave)
    {
        return nullptr;
    }

    if (NewPlayerId.IsEmpty() || StartingMoney < 0)
    {
        return nullptr;
    }

    UVNHSaveGame* NewSave = Cast<UVNHSaveGame>(
        UGameplayStatics::CreateSaveGameObject(UVNHSaveGame::StaticClass()));

    if (!IsValid(NewSave))
    {
        return nullptr;
    }

    NewSave->SchemaVersion = UVNHSaveGame::CurrentSchemaVersion;
    NewSave->PlayerId = MoveTemp(NewPlayerId);
    NewSave->PlayerLevel = 1;
    NewSave->HomeRegionId = TEXT("HANOI_HOAN_KIEM");
    NewSave->HomeLocationId = TEXT("FAMILY_HOME_STARTER");
    NewSave->MotherCharacterId = TEXT("FAMILY_MOTHER");
    NewSave->FatherCharacterId = TEXT("FAMILY_FATHER");
    NewSave->SelectedJobId = NAME_None;
    NewSave->WorkplaceId = NAME_None;
    NewSave->MonthlySalary = 0;
    NewSave->CompletedWorkShifts = 0;
    NewSave->Money = StartingMoney;
    NewSave->CurrentRegionId = NewSave->HomeRegionId;
    NewSave->LastCheckpointId = NAME_None;

    return SaveProgress(NewSave) ? NewSave : nullptr;
}

UVNHSaveGame* UVNHSaveSubsystem::LoadOrCreateProgress()
{
    if (HasLocalSave())
    {
        return LoadProgress();
    }

    // Do not silently create a profile with invented money or career settings.
    return nullptr;
}

bool UVNHSaveSubsystem::SelectCareer(FName JobId, FName WorkplaceId, int64 InMonthlySalary)
{
    if (JobId.IsNone() || WorkplaceId.IsNone() || InMonthlySalary < 0)
    {
        return false;
    }

    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData))
    {
        return false;
    }

    SaveData->SelectedJobId = JobId;
    SaveData->WorkplaceId = WorkplaceId;
    SaveData->MonthlySalary = InMonthlySalary;
    return SaveProgress(SaveData);
}

bool UVNHSaveSubsystem::ClearCareerSelection()
{
    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData))
    {
        return false;
    }

    SaveData->SelectedJobId = NAME_None;
    SaveData->WorkplaceId = NAME_None;
    SaveData->MonthlySalary = 0;
    return SaveProgress(SaveData);
}

bool UVNHSaveSubsystem::SaveCheckpoint(FName RegionId, FName CheckpointId)
{
    if (RegionId.IsNone() || CheckpointId.IsNone())
    {
        return false;
    }

    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData))
    {
        return false;
    }

    SaveData->CurrentRegionId = RegionId;
    SaveData->LastCheckpointId = CheckpointId;
    return SaveProgress(SaveData);
}

int64 UVNHSaveSubsystem::GetMoney()
{
    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    return IsValid(SaveData) ? SaveData->Money : 0;
}

bool UVNHSaveSubsystem::TrySpendMoney(int64 Amount)
{
    if (Amount <= 0)
    {
        return false;
    }

    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData) || SaveData->Money < Amount)
    {
        return false;
    }

    SaveData->Money -= Amount;
    return SaveProgress(SaveData);
}

bool UVNHSaveSubsystem::AddMoney(int64 Amount)
{
    if (Amount <= 0)
    {
        return false;
    }

    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData))
    {
        return false;
    }

    SaveData->Money = (MAX_int64 - SaveData->Money < Amount)
        ? MAX_int64
        : SaveData->Money + Amount;
    return SaveProgress(SaveData);
}
