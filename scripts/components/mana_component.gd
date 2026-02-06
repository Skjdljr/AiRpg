extends Node2D
class_name ManaComponent

@export var maxMana := 100.0
@export var useMana := true

var currentMana := 0.0

func HasManaRemaining() -> bool:
	return is_equal_approx(currentMana, 0.0)

func GetManaPercentage() -> float:
	if maxMana > 0:
		return currentMana / maxMana
	else:
		return 0
		
func GetMaxMana() -> float:
	return maxMana

func GetMana() -> float:
	return currentMana

func SetMana(mana: float) -> void:
	if mana <= 0:
		currentMana = 0
	elif mana > maxMana:
		currentMana = maxMana
	else:
		currentMana = mana

func UseMana(amount: float) -> void:
	if useMana:
		SetMana(GetMana() - amount)
		
func AddMana(amount: float) -> void: 
	SetMana(GetMana() + amount)

func SetmaxMana(newmaxMana: float) -> void:
	maxMana = newmaxMana
	SetMana(currentMana)


func InitializeMana() -> void:
	currentMana = maxMana

#func ApplyScaling(curve: Curve, progress: float ):
#	callDeferred("ApplyScalingInternal", curve, progress)

func ApplyScalingInternal(curve : Curve, progress:float ) -> void:
	var curveVal : float = curve.sample(progress)
	maxMana *= 1.0 + curveVal
	currentMana = maxMana
	
	
