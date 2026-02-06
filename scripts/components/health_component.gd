@tool
extends Node
class_name HealthComponent
signal DiedEventHandler

@export var healthBar : ProgressBar = null
@export var healthLabel : Label = null
@export var maxHealth := 100.0
@export var suppressDamage := false
@export var showHealthBar := true
@export var showHealthText := true

@onready var currentHealth := maxHealth
signal damaged

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = PackedStringArray()
	if healthLabel == null:
		warnings.append("HealthLabel not set for..")
	if healthBar == null:
		warnings.append("HealthBar not set for..")
	return warnings

func _ready() -> void:
	setProgressBar()
	if healthLabel != null :
		healthLabel.text = str(currentHealth)
		
	if healthBar != null:
		healthBar.value = currentHealth

func HasHealthRemaining() -> bool:
	return is_equal_approx(currentHealth, 0.0)

func GetHealthPercentage() -> float:
	if maxHealth > 0:
		return currentHealth / maxHealth
	else:
		return 0
		
func GetMaxHealth() -> float:
	return maxHealth

func GetHealth() -> float:
	return currentHealth

func SetHealth(health: float) -> void:
	if health <= 0:
		currentHealth = 0
		Die()
	elif health > maxHealth:
		currentHealth = maxHealth
	else:
		currentHealth = health

	if healthLabel != null:
		healthLabel.text = str(currentHealth)
	if healthBar != null:
		healthBar.value = currentHealth

func TakeDamage(damage: float) -> void:
	if !suppressDamage:
		emit_signal("damaged", damage)
		SetHealth(GetHealth() - damage)
		
func Heal(health: int) -> void: 
	SetHealth(GetHealth() + health)

func SetMaxHealth(newMaxHealth: int) -> void:
	maxHealth = newMaxHealth
	SetHealth(currentHealth)

func Die() -> void:
	print(owner.name + " DIED!")
	emit_signal("DiedEventHandler", owner)
	owner.queue_free() 

func InitializeHealth() -> void:
	currentHealth = maxHealth

func ApplyScaling(_curve: Curve, _progress: float ) -> void:
	#callDeferred("ApplyScalingInternal", curve, progress)
	pass

func ApplyScalingInternal(curve : Curve, progress:float ) -> void:
	var curveVal : float = curve.sample((progress))
	maxHealth *= (1.0 + curveVal)
	currentHealth = maxHealth
	
func setProgressBar() -> void:
	var progressBar : ProgressBar = ProgressBar.new()
	
	# Set the size of the ProgressBar
	var size := Vector2(300, 25)
	progressBar.custom_minimum_size = Vector2(100,0)
	progressBar.set_size(size)
	
	progressBar.set_position(Vector2(100, 100)) # Position in the parent container

	# Set the range of the ProgressBar (e.g., 0 to 100)
	progressBar.min_value = 0
	progressBar.max_value = 100
	
	# Set the current value of the ProgressBar
	progressBar.value = 50  # Example value
	
	#owner.add_child(progressBar)
	
