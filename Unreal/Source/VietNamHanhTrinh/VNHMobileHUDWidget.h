#pragma once

#include "CoreMinimal.h"
#include "Blueprint/UserWidget.h"
#include "VNHMobileHUDWidget.generated.h"

class AVNHPlayerCharacter;
class AVNHVehiclePawn;

/**
 * Thin Blueprint-facing input bridge for a mobile UMG HUD.
 * Build the visual joystick/buttons in a Widget Blueprint and bind their
 * touch/pressed/released events to these functions.
 */
UCLASS(Abstract, Blueprintable)
class VIETNAMHANHTRINH_API UVNHMobileHUDWidget : public UUserWidget
{
    GENERATED_BODY()

public:
    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD")
    void SetMoveStick(FVector2D Axis);

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD")
    void ClearMoveStick();

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD")
    void AddLookDrag(FVector2D Delta);

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD")
    void SetSprintHeld(bool bHeld);

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD")
    void SetJumpHeld(bool bHeld);

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD")
    void PressInteract();

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD|Vehicle")
    void SetVehicleThrottleInput(float Value);

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD|Vehicle")
    void SetVehicleSteeringInput(float Value);

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD|Vehicle")
    void SetVehicleBrakeInput(bool bPressed);

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile HUD|Vehicle")
    void PressExitVehicle();

protected:
    UFUNCTION(BlueprintPure, Category="VNH|Mobile HUD")
    AVNHPlayerCharacter* GetVNHCharacter() const;

    UFUNCTION(BlueprintPure, Category="VNH|Mobile HUD|Vehicle")
    AVNHVehiclePawn* GetVNHVehicle() const;

private:
    float VehicleThrottleInput = 0.0f;
    float VehicleSteeringInput = 0.0f;
};
