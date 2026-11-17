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
