extends CharacterBody2D
class_name Enemy

# Simple state machine
enum State { IDLE, CHASING, ATTACKING, RETURN }
var current_state: State = State.IDLE

# Movement
@export var speed := 100.0
@export var attack_range := 50.0
@export var aggro_range := 300.0

# References
var target: Node2D = null
var spawn_point: Vector2
var distance_traveled: float = 0.0

# Attack
@export var attack_cooldown_max := 1.0
var attack_cooldown: float = 0.0
var base_damage := 5.0  # Will be set by FloorManager

func _ready() -> void:
	target = Globals.player
	if not target:
		push_error("Enemy: Globals.player not set!")
	spawn_point = global_position
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	
	var distance_to_target = global_position.distance_to(target.global_position)
	var direction_to_target = (target.global_position - global_position).normalized()
	
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			if distance_to_target <= aggro_range:
				current_state = State.CHASING
				distance_traveled = 0.0
		
		State.CHASING:
			if distance_to_target <= attack_range:
				current_state = State.ATTACKING
				velocity = Vector2.ZERO
			elif distance_to_target <= aggro_range:
				velocity = direction_to_target * speed
				distance_traveled += velocity.length() * delta
			else:
				current_state = State.RETURN
				distance_traveled = 0.0
		
		State.ATTACKING:
			velocity = Vector2.ZERO
			attack_cooldown -= delta
			if attack_cooldown <= 0:
				perform_attack()
				attack_cooldown = attack_cooldown_max
			
			# Exit attack range
			if distance_to_target > attack_range:
				current_state = State.CHASING
		
		State.RETURN:
			var direction_to_spawn = (spawn_point - global_position).normalized()
			var distance_to_spawn = global_position.distance_to(spawn_point)
			
			if distance_to_spawn > 10.0:
				velocity = direction_to_spawn * speed
			else:
				current_state = State.IDLE
				velocity = Vector2.ZERO
				distance_traveled = 0.0
	
	move_and_slide()

func perform_attack() -> void:
	"""Attack the target"""
	if is_instance_valid(target) and target.has_method("TakeDamage"):
		target.TakeDamage(base_damage)
		print("%s attacks for %d damage!" % [name, base_damage])

func TakeDamage(damage: float) -> void:
	"""Take damage and potentially die"""
	var health_comp = $Components/HealthComponent
	if health_comp and health_comp.has_method("TakeDamage"):
		health_comp.TakeDamage(damage)
	else:
		push_error("Enemy missing HealthComponent!")
