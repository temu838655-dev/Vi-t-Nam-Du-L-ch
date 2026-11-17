#pragma once
#include "CoreMinimal.h"
#include "GameFramework/SaveGame.h"
#include "VNHSaveGame.generated.h"

USTRUCT(BlueprintType)
struct FVNHSavedItem
{
    GENERATED_BODY()
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName ItemId = NAME_None;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) int32 Quantity = 0;
};

// Appearance is stored as stable preset IDs and normalized parameters, not asset pointers.
USTRUCT(BlueprintType)
struct FVNHSavedAppearance
{
    GENERATED_BODY()
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName BodyTypeId = TEXT("BODY_AVERAGE");
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName FacePresetId = TEXT("FACE_VN_01");
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName SkinToneId = TEXT("SKIN_TONE_03");
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName HairStyleId = TEXT("HAIR_SHORT_01");
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName HairColorId = TEXT("HAIR_BLACK");
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName OutfitId = TEXT("OUTFIT_CASUAL_01");
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) float HeightCm = 170.0f;
};

// A local-time activity interval. Minutes are measured from midnight; end is exclusive.
USTRUCT(BlueprintType)
struct FVNHDailyRoutineEntry
{
    GENERATED_BODY()
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) int32 StartMinute = 0;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) int32 EndMinute = 60;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName ActivityId = NAME_None;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName LocationId = NAME_None;
};

// Persistent family state. Dialogue and animation are driven by gameplay systems.
USTRUCT(BlueprintType)
struct FVNHFamilyMemberSave
{
    GENERATED_BODY()
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName CharacterId = NAME_None;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName FamilyRoleId = NAME_None;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName DisplayNameKey = NAME_None;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) int32 AgeYears = 0;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) int32 Relationship = 50;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName DailyRoutineId = NAME_None;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) FName AppearancePresetId = NAME_None;
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame) TArray<FVNHDailyRoutineEntry> DailyRoutine;
};

UCLASS(BlueprintType)
class VIETNAMHANHTRINH_API UVNHSaveGame : public USaveGame
{
    GENERATED_BODY()
public:
    static constexpr int32 CurrentSchemaVersion = 5;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Save") int32 SchemaVersion = CurrentSchemaVersion;

    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Player") FString PlayerId;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Player") int32 PlayerLevel = 1;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Player|Appearance") FVNHSavedAppearance PlayerAppearance;

    // Home and family are permanent life-simulation data, not respawn-only metadata.
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Home") FName HomeRegionId = TEXT("HANOI_HOAN_KIEM");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Home") FName HomeLocationId = TEXT("FAMILY_HOME_STARTER");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Family") FName MotherCharacterId = TEXT("FAMILY_MOTHER");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Family") FName FatherCharacterId = TEXT("FAMILY_FATHER");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Family") TArray<FVNHFamilyMemberSave> FamilyMembers;

    // Player chooses a career; NAME_None means no career has been selected.
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Career") FName SelectedJobId = NAME_None;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Career") FName WorkplaceId = NAME_None;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Career") int64 MonthlySalary = 0;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Life|Career") int32 CompletedWorkShifts = 0;

    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Economy") int64 Money = 0;
    // In-game calendar: Day 1, Monday (weekday index 0), starts at 08:00.
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="World|Time") int64 GameDay = 1;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="World|Time") int32 MinuteOfDay = 480;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="World|Time") int32 WeekdayIndex = 0;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="World") FName CurrentRegionId = TEXT("HANOI_HOAN_KIEM");
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="World") FName LastCheckpointId = NAME_None;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Progress") TArray<FName> CompletedMissionIds;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Inventory") TArray<FVNHSavedItem> Inventory;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Sync") int64 LocalRevision = 0;
    UPROPERTY(VisibleAnywhere, BlueprintReadWrite, SaveGame, Category="Sync") FString LastLocalSaveUtc;
};
