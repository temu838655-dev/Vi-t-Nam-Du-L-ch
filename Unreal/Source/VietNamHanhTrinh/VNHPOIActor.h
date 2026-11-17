#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "VNHInteractable.h"
#include "VNHPOIActor.generated.h"

class UStaticMeshComponent;

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHPOIActor : public AActor, public IVNHInteractable
{
    GENERATED_BODY()

public:
    AVNHPOIActor();

    virtual void Interact_Implementation(AActor* InteractingActor) override;

    UPROPERTY(EditInstanceOnly, BlueprintReadOnly, Category="Point of Interest")
    FName PointId = NAME_None;

    UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Point of Interest")
    FText DisplayName;

    UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Point of Interest", meta=(MultiLine=true))
    FText Description;

    UFUNCTION(BlueprintImplementableEvent, Category="Point of Interest")
    void OnPointOfInterestInteracted(AActor* InteractingActor);

private:
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Point of Interest", meta=(AllowPrivateAccess="true"))
    TObjectPtr<UStaticMeshComponent> PlaceholderMesh;
};
