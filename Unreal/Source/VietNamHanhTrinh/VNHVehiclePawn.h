#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Pawn.h"
#include "VNHInteractable.h"
#include "VNHVehiclePawn.generated.h"

class UCameraComponent;
class USpringArmComponent;
class UStaticMeshComponent;
class ACharacter;
class AController;
class AVNHTrafficRoute;

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHVehiclePawn : public APawn, public IVNHInteractable
{
    GENERATED_BODY()

public:
    AVNHVehiclePawn();
    virtual void Tick(float DeltaSeconds) override;
    virtual void SetupPlayerInputComponent(UInputComponent* PlayerInputComponent) override;
    virtual void Interact_Implementation(AActor* InteractingActor) override;

    UFUNCTION(BlueprintCallable, Category="VNH|Vehicle")
    void SetVehicleInput(float Throttle, float Steering);

    UFUNCTION(BlueprintCallable, Category="VNH|Vehicle")
    void SetBrake(bool bPressed);

    UFUNCTION(BlueprintCallable, Category="VNH|Vehicle")
    void ExitVehicle();

    UFUNCTION(BlueprintPure, Category="VNH|Traffic")
    AVNHTrafficRoute* GetTrafficRoute() const { return TrafficRoute; }

    UPROPERTY(EditInstanceOnly, BlueprintReadWrite, Category="VNH|Traffic")
    TObjectPtr<AVNHTrafficRoute> TrafficRoute;

protected:
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Vehicle")
    TObjectPtr<UStaticMeshComponent> VehicleBody;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Vehicle|Camera")
    TObjectPtr<USpringArmComponent> CameraBoom;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Vehicle|Camera")
    TObjectPtr<UCameraComponent> VehicleCamera;

    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Handling")
    float MaxForwardSpeed = 2400.0f;

    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Handling")
    float Acceleration = 950.0f;

    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Handling")
    float BrakeDeceleration = 2200.0f;

    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Handling")
    float SteeringRate = 85.0f;

private:
    UPROPERTY(Transient)
    TObjectPtr<ACharacter> PreviousCharacter;

    UPROPERTY(Transient)
    TArray<TObjectPtr<UStaticMeshComponent>> WheelMeshes;

    float CurrentSpeed = 0.0f;
    float ThrottleInput = 0.0f;
    float SteeringInput = 0.0f;
    bool bBrakePressed = false;

    void ThrottleKeyboard(float Value);
    void SteerKeyboard(float Value);
    void BrakePressed();
    void BrakeReleased();
    void ExitVehicleKeyboard();
    void UpdateWheelVisuals(float DeltaSeconds);
};
