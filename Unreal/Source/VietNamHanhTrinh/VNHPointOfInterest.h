#pragma once
#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "VNHInteractable.h"
#include "VNHPointOfInterest.generated.h"

class UStaticMeshComponent;

UCLASS(Blueprintable)
class VIETNAMHANHTRINH_API AVNHPointOfInterest : public AActor, public IVNHInteractable
{
    GENERATED_BODY()
public:
    AVNHPointOfInterest();

    virtual void Interact_Implementation(AActor* InteractingActor) override;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="VNH|POI")
    TObjectPtr<UStaticMeshComponent> Visual;

    UPROPERTY(EditInstanceOnly, BlueprintReadWrite, Category="VNH|POI")
    FName PointOfInterestId = NAME_None;

    UPROPERTY(EditInstanceOnly, BlueprintReadWrite, Category="VNH|POI")
    FText DisplayName;

    UPROPERTY(EditInstanceOnly, BlueprintReadWrite, Category="VNH|POI", meta=(MultiLine=true))
    FText Description;

    UFUNCTION(BlueprintImplementableEvent, Category="VNH|POI")
    void OnPointOfInterestInteracted(AActor* InteractingActor);
};
