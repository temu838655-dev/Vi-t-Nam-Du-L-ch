#pragma once
#include "CoreMinimal.h"
#include "GameFramework/Pawn.h"
#include "VNHInteractable.h"
#include "VNHDriveableVehicle.generated.h"

class UBoxComponent;
class UStaticMeshComponent;
class USpringArmComponent;
class UCameraComponent;
class AVNHPlayerCharacter;
class APlayerController;

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHDriveableVehicle : public APawn, public IVNHInteractable
{
    GENERATED_BODY()
public:
    AVNHDriveableVehicle();
    virtual void Tick(float DeltaSeconds) override;
    virtual void SetupPlayerInputComponent(UInputComponent* PlayerInputComponent) override;
    virtual void Interact_Implementation(AActor* InteractingActor) override;

    UFUNCTION(BlueprintCallable, Category="VNH|Vehicle")
    void SetVehicleInput(float Throttle, float Steering);
    UFUNCTION(BlueprintCallable, Category="VNH|Vehicle")
    void SetBrakeInput(bool bBraking);
    UFUNCTION(BlueprintCallable, Category="VNH|Vehicle")
    void ExitVehicle();
    UFUNCTION(BlueprintPure, Category="VNH|Vehicle")
    float GetSpeedKmh() const;

protected:
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Vehicle")
    TObjectPtr<UBoxComponent> CollisionBox;
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Vehicle")
    TObjectPtr<UStaticMeshComponent> VehicleMesh;
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Camera")
    TObjectPtr<USpringArmComponent> CameraBoom;
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Camera")
    TObjectPtr<UCameraComponent> VehicleCamera;

    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Tuning")
    float MaxForwardSpeed = 1800.0f;
    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Tuning")
    float MaxReverseSpeed = 500.0f;
    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Tuning")
    float Acceleration = 650.0f;
    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Tuning")
    float BrakeDeceleration = 1500.0f;
    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Tuning")
    float CoastDeceleration = 100.0f;
    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Vehicle|Tuning")
    float SteeringRate = 75.0f;

private:
    UPROPERTY(Transient)
    TObjectPtr<AVNHPlayerCharacter> CurrentPassenger;
    UPROPERTY(Transient)
    TObjectPtr<APlayerController> VehicleController;
    float CurrentSpeed = 0.0f;
    float ThrottleInput = 0.0f;
    float SteeringInput = 0.0f;
    bool bBrakeInput = false;

    void ThrottleAxis(float Value);
    void SteeringAxis(float Value);
    void BrakePressed();
    void BrakeReleased();
    void ExitPressed();
};
