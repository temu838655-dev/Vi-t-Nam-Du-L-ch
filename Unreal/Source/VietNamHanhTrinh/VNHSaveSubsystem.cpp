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

    if (SaveData->SchemaVersion < 2)
    {
        if (SaveData->HomeRegionId.IsNone()) SaveData->HomeRegionId = TEXT("HANOI_HOAN_KIEM");
        if (SaveData->HomeLocationId.IsNone()) SaveData->HomeLocationId = TEXT("FAMILY_HOME_STARTER");
        if (SaveData->MotherCharacterId.IsNone()) SaveData->MotherCharacterId = TEXT("FAMILY_MOTHER");
        if (SaveData->FatherCharacterId.IsNone()) SaveData->FatherCharacterId = TEXT("FAMILY_FATHER");
        SaveData->SchemaVersion = 2;
    }

    if (SaveData->SchemaVersion < 3)
    {
        // Existing saves receive a safe appearance preset and family records.
        // No career is selected automatically and the saved balance/location remain untouched.
        if (SaveData->PlayerAppearance.BodyTypeId.IsNone())
            SaveData->PlayerAppearance.BodyTypeId = TEXT("BODY_AVERAGE");
        if (SaveData->PlayerAppearance.FacePresetId.IsNone())
            SaveData->PlayerAppearance.FacePresetId = TEXT("FACE_VN_01");
        if (SaveData->PlayerAppearance.SkinToneId.IsNone())
            SaveData->PlayerAppearance.SkinToneId = TEXT("SKIN_TONE_03");
        if (SaveData->PlayerAppearance.HairStyleId.IsNone())
            SaveData->PlayerAppearance.HairStyleId = TEXT("HAIR_SHORT_01");
        if (SaveData->PlayerAppearance.HairColorId.IsNone())
            SaveData->PlayerAppearance.HairColorId = TEXT("HAIR_BLACK");
        if (SaveData->PlayerAppearance.OutfitId.IsNone())
            SaveData->PlayerAppearance.OutfitId = TEXT("OUTFIT_CASUAL_01");

        if (SaveData->FamilyMembers.Num() == 0)
        {
            FVNHFamilyMemberSave Mother;
            Mother.CharacterId = SaveData->MotherCharacterId;
            Mother.FamilyRoleId = TEXT("MOTHER");
            Mother.DisplayNameKey = TEXT("FAMILY_MOTHER_NAME");
            Mother.AgeYears = 48;
            Mother.Relationship = 60;
            Mother.DailyRoutineId = TEXT("ROUTINE_PARENT_HOME");
            Mother.AppearancePresetId = TEXT("PARENT_MOTHER_01");
            SaveData->FamilyMembers.Add(Mother);

            FVNHFamilyMemberSave Father;
            Father.CharacterId = SaveData->FatherCharacterId;
            Father.FamilyRoleId = TEXT("FATHER");
            Father.DisplayNameKey = TEXT("FAMILY_FATHER_NAME");
            Father.AgeYears = 52;
            Father.Relationship = 60;
            Father.DailyRoutineId = TEXT("ROUTINE_PARENT_HOME");
            Father.AppearancePresetId = TEXT("PARENT_FATHER_01");
            SaveData->FamilyMembers.Add(Father);
        }
        SaveData->SchemaVersion = 3;
    }

    return SaveData->SchemaVersion == UVNHSaveGame::CurrentSchemaVersion;
}

UVNHSaveGame* UVNHSaveSubsystem::LoadProgress()
{
    if (!HasLocalSave()) return nullptr;
    UVNHSaveGame* LoadedSave = Cast<UVNHSaveGame>(
        UGameplayStatics::LoadGameFromSlot(SaveSlotName, UserIndex));
    if (!IsValid(LoadedSave)) return nullptr;

    const int32 LoadedSchemaVersion = LoadedSave->SchemaVersion;
    if (!MigrateSaveData(LoadedSave)) return nullptr;
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
    if (HasLocalSave() && !bReplaceExistingSave) return nullptr;
    if (NewPlayerId.IsEmpty() || StartingMoney < 0) return nullptr;

    UVNHSaveGame* NewSave = Cast<UVNHSaveGame>(
        UGameplayStatics::CreateSaveGameObject(UVNHSaveGame::StaticClass()));
    if (!IsValid(NewSave)) return nullptr;

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

    FVNHFamilyMemberSave Mother;
    Mother.CharacterId = NewSave->MotherCharacterId;
    Mother.FamilyRoleId = TEXT("MOTHER");
    Mother.DisplayNameKey = TEXT("FAMILY_MOTHER_NAME");
    Mother.AgeYears = 48;
    Mother.Relationship = 60;
    Mother.DailyRoutineId = TEXT("ROUTINE_PARENT_HOME");
    Mother.AppearancePresetId = TEXT("PARENT_MOTHER_01");
    NewSave->FamilyMembers.Add(Mother);

    FVNHFamilyMemberSave Father;
    Father.CharacterId = NewSave->FatherCharacterId;
    Father.FamilyRoleId = TEXT("FATHER");
    Father.DisplayNameKey = TEXT("FAMILY_FATHER_NAME");
    Father.AgeYears = 52;
    Father.Relationship = 60;
    Father.DailyRoutineId = TEXT("ROUTINE_PARENT_HOME");
    Father.AppearancePresetId = TEXT("PARENT_FATHER_01");
    NewSave->FamilyMembers.Add(Father);

    return SaveProgress(NewSave) ? NewSave : nullptr;
}

UVNHSaveGame* UVNHSaveSubsystem::LoadOrCreateProgress()
{
    return HasLocalSave() ? LoadProgress() : nullptr;
}

bool UVNHSaveSubsystem::SelectCareer(FName JobId, FName WorkplaceId, int64 InMonthlySalary)
{
    if (JobId.IsNone() || WorkplaceId.IsNone() || InMonthlySalary < 0) return false;
    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData)) return false;
    SaveData->SelectedJobId = JobId;
    SaveData->WorkplaceId = WorkplaceId;
    SaveData->MonthlySalary = InMonthlySalary;
    return SaveProgress(SaveData);
}

bool UVNHSaveSubsystem::ClearCareerSelection()
{
    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData)) return false;
    SaveData->SelectedJobId = NAME_None;
    SaveData->WorkplaceId = NAME_None;
    SaveData->MonthlySalary = 0;
    return SaveProgress(SaveData);
}

bool UVNHSaveSubsystem::UpdateFamilyRelationship(FName CharacterId, int32 Delta)
{
    if (CharacterId.IsNone() || Delta == 0) return false;
    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData)) return false;

    for (FVNHFamilyMemberSave& Member : SaveData->FamilyMembers)
    {
        if (Member.CharacterId == CharacterId)
        {
            Member.Relationship = static_cast<int32>(FMath::Clamp<int64>(
                static_cast<int64>(Member.Relationship) + static_cast<int64>(Delta), 0, 100));
            return SaveProgress(SaveData);
        }
    }
    return false;
}

bool UVNHSaveSubsystem::SetPlayerAppearance(const FVNHSavedAppearance& Appearance)
{
    if (Appearance.BodyTypeId.IsNone() || Appearance.FacePresetId.IsNone() ||
        Appearance.SkinToneId.IsNone() || Appearance.HairStyleId.IsNone() ||
        Appearance.HairColorId.IsNone() || Appearance.OutfitId.IsNone() ||
        !FMath::IsFinite(Appearance.HeightCm) || Appearance.HeightCm < 120.0f ||
        Appearance.HeightCm > 220.0f)
    {
        return false;
    }

    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData)) return false;
    SaveData->PlayerAppearance = Appearance;
    return SaveProgress(SaveData);
}

bool UVNHSaveSubsystem::SaveCheckpoint(FName RegionId, FName CheckpointId)
{
    if (RegionId.IsNone() || CheckpointId.IsNone()) return false;
    UVNHSaveGame* SaveData = LoadOrCreateProgress();
    if (!IsValid(SaveData)) return false;
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
        ? MAX_int64 : SaveData->Money + Amount;
    return SaveProgress(SaveData);
}
