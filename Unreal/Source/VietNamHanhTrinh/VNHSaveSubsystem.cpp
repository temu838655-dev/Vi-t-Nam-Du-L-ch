#include "VNHSaveSubsystem.h"
#include "Kismet/GameplayStatics.h"
#include "Misc/DateTime.h"

bool UVNHSaveSubsystem::SaveProgress(UVNHSaveGame* SaveData)
{
    if (!IsValid(SaveData)) return false;
    SaveData->SchemaVersion = UVNHSaveGame::CurrentSchemaVersion;
    SaveData->LocalRevision = FMath::Max<int64>(0, SaveData->LocalRevision) + 1;
    SaveData->LastLocalSaveUtc = FDateTime::UtcNow().ToIso8601();
    return UGameplayStatics::SaveGameToSlot(SaveData, SaveSlotName, UserIndex);
}

UVNHSaveGame* UVNHSaveSubsystem::LoadProgress()
{
    if (!HasLocalSave()) return nullptr;
    UVNHSaveGame* LoadedSave = Cast<UVNHSaveGame>(UGameplayStatics::LoadGameFromSlot(SaveSlotName, UserIndex));
    if (!IsValid(LoadedSave) || LoadedSave->SchemaVersion > UVNHSaveGame::CurrentSchemaVersion) return nullptr;
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


UVNHSaveGame* UVNHSaveSubsystem::LoadOrCreateProgress()
{
    if (HasLocalSave())
    {
        return LoadProgress();
    }

    UVNHSaveGame* NewSave = Cast<UVNHSaveGame>(
        UGameplayStatics::CreateSaveGameObject(UVNHSaveGame::StaticClass()));
    if (!IsValid(NewSave)) return nullptr;

    NewSave->Money = 100000;
    if (!SaveProgress(NewSave)) return nullptr;
    return NewSave;
}

int64 UVNHSaveSubsystem::GetMoney()
{
    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    return IsValid(SaveData) ? SaveData->Money : 0;
}

bool UVNHSaveSubsystem::TrySpendMoney(int64 Amount)
{
    if (Amount <= 0) return false;
    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData) || SaveData->Money < Amount) return false;

    SaveData->Money -= Amount;
    return SaveProgress(SaveData);
}

bool UVNHSaveSubsystem::AddMoney(int64 Amount)
{
    if (Amount <= 0) return false;
    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData)) return false;

    SaveData->Money = (MAX_int64 - SaveData->Money < Amount)
        ? MAX_int64
        : SaveData->Money + Amount;
    return SaveProgress(SaveData);
}
