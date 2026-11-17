#include "VNHMobileHUDWidget.h"

#include "VNHPlayerCharacter.h"
#include "VNHVehiclePawn.h"

AVNHPlayerCharacter* UVNHMobileHUDWidget::GetVNHCharacter() const
{
    return Cast<AVNHPlayerCharacter>(GetOwningPlayerPawn());
}

AVNHVehiclePawn* UVNHMobileHUDWidget::GetVNHVehicle() const
{
    return Cast<AVNHVehiclePawn>(GetOwningPlayerPawn());
}

void UVNHMobileHUDWidget::SetMoveStick(FVector2D Axis)
{
    if (AVNHPlayerCharacter* Character = GetVNHCharacter())
    {
        Character->SetMoveInput(Axis.Y, Axis.X);
    }
}

void UVNHMobileHUDWidget::ClearMoveStick()
{
    SetMoveStick(FVector2D::ZeroVector);
}

void UVNHMobileHUDWidget::AddLookDrag(FVector2D Delta)
{
    if (AVNHPlayerCharacter* Character = GetVNHCharacter())
    {
        Character->AddLookInput(Delta.X, Delta.Y);
    }
}

void UVNHMobileHUDWidget::SetSprintHeld(bool bHeld)
{
    if (AVNHPlayerCharacter* Character = GetVNHCharacter())
    {
        Character->SetSprinting(bHeld);
    }
}

void UVNHMobileHUDWidget::SetJumpHeld(bool bHeld)
{
    if (AVNHPlayerCharacter* Character = GetVNHCharacter())
    {
        if (bHeld) Character->TriggerJump();
        else Character->StopJump();
    }
}

void UVNHMobileHUDWidget::PressInteract()
{
    if (AVNHPlayerCharacter* Character = GetVNHCharacter())
    {
        Character->TryInteract();
    }
}

void UVNHMobileHUDWidget::SetVehicleThrottleInput(float Value)
{
    VehicleThrottleInput = FMath::Clamp(Value, -1.0f, 1.0f);
    if (AVNHVehiclePawn* Vehicle = GetVNHVehicle())
    {
        Vehicle->SetVehicleInput(VehicleThrottleInput, VehicleSteeringInput);
    }
}

void UVNHMobileHUDWidget::SetVehicleSteeringInput(float Value)
{
    VehicleSteeringInput = FMath::Clamp(Value, -1.0f, 1.0f);
    if (AVNHVehiclePawn* Vehicle = GetVNHVehicle())
    {
        Vehicle->SetVehicleInput(VehicleThrottleInput, VehicleSteeringInput);
    }
}

void UVNHMobileHUDWidget::SetVehicleBrakeInput(bool bPressed)
{
    if (AVNHVehiclePawn* Vehicle = GetVNHVehicle())
    {
        Vehicle->SetBrake(bPressed);
    }
}

void UVNHMobileHUDWidget::PressExitVehicle()
{
    if (AVNHVehiclePawn* Vehicle = GetVNHVehicle())
    {
        Vehicle->SetVehicleInput(0.0f, 0.0f);
        Vehicle->SetBrake(false);
        Vehicle->ExitVehicle();
    }
    VehicleThrottleInput = 0.0f;
    VehicleSteeringInput = 0.0f;
}
