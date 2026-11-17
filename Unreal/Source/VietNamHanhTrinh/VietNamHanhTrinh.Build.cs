using UnrealBuildTool;

public class VietNamHanhTrinh : ModuleRules
{
    public VietNamHanhTrinh(ReadOnlyTargetRules Target) : base(Target)
    {
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
        PublicDependencyModuleNames.AddRange(new[]
        {
            "Core",
            "CoreUObject",
            "Engine",
            "UMG",
            "InputCore",
            "AIModule",
            "NavigationSystem"
        });
    }
}
