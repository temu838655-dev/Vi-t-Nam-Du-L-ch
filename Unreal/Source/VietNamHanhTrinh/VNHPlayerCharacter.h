#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "VNHPlayerCharacter.generated.h"

class USpringArmComponent;
class UCameraComponent;

UCLASS()
class VIETNAMHANHTRINH_API AVNHPlayerCharacter : public ACharacter
{
    GENERATED_BODY()
public:
    AVNHPlayerCharacter();

    UFUNCTION(BlueprintCallable, Category="VNH|Mobile Controls")
    void SetMoveInput(float Forward, float Right);
    UFUNCTION(BlueprintCallable, Category="VNH|Mobile Controls")
    void AddLookInput(float DeltaX, float DeltaY);
    UFUNCTION(BlueprintCallable, Category="VNH|Mobile Controls")
    void SetSprinting(bool bNewSprinting);
    UFUNCTION(BlueprintCallable, Category="VNH|Mobile Controls")
    void TriggerJump();
    UFUNCTION(BlueprintCallable, Category="VNH|Mobile Controls")
    void StopJump();

private:
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Camera", meta=(AllowPrivateAccess="true"))
    TObjectPtr<USpringArmComponent> CameraBoom;
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Camera", meta=(AllowPrivateAccess="true"))
    TObjectPtr<UCameraComponent> PlayerCamera;
    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Movement", meta=(AllowPrivateAccess="true"))
    float WalkSpeed = 360.0f;
    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Movement", meta=(AllowPrivateAccess="true"))
    float SprintSpeed = 560.0f;
    UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category="Camera", meta=(AllowPrivateAccess="true"))
    float TouchLookSensitivity = 0.12f;

    void MoveForwardKeyboard(float Value);
    void MoveRightKeyboard(float Value);
    void TurnKeyboard(float Value);
    void LookUpKeyboard(float Value);
    void StartKeyboardJump();
    void StopKeyboardJump();
};
