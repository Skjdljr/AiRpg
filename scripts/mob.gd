extends CharacterBody2D

# Enum for states
enum State { IDLE, AGGRESSIVE, RETURNING, ATTACKING }
var state: State = State.IDLE

var deaggro_timer: float = 0.0
var spawn_point: Vector2
var target: Node2D = null

@export var speed := 100
# Variables for aggression management
@export var aggro_radius: float = 300.0
@export var deaggro_radius: float = 350.0
@export var attack_radius: float = 50.0
# Timer for de-aggro check (optional)
@export var deaggro_time: float = 5.0


# Attack cooldown
@export var attack_cooldown: float = 1.0
var attack_timer: float = 0.0

func _ready() -> void:
	target = Globals.player
	spawn_point = global_position

func _process(delta : float) -> void:
	match state:
		State.IDLE:
			check_aggro()
		State.AGGRESSIVE:
			if target:
				pursue_target(delta)
			check_deaggro(delta)
			check_attack()
		State.RETURNING:
			return_to_spawn(delta)
		State.ATTACKING:
			perform_attack(delta)

# Check if a target is within the aggro radius
func check_aggro() -> void:
	if target and global_position.distance_to(target.global_position) <= aggro_radius:
		state = State.AGGRESSIVE

# Pursue the target (simplified)
func pursue_target(delta : float) -> void:
	var direction : Vector2 = (target.global_position - global_position).normalized() * speed
	move_and_slide()  # Adjust speed as necessary

# Check if the target is within the attack radius
func check_attack() -> void:
	if target and global_position.distance_to(target.global_position) <= attack_radius:
		state = State.ATTACKING

# Perform the attack
func perform_attack(delta : float) -> void:
	if attack_timer <= 0:
		# Perform the attack (e.g., deal damage to the target)
		print("Attacking target!")
		attack_timer = attack_cooldown
	else:
		attack_timer -= delta
	
	# Check if the target moved out of attack range
	if target and global_position.distance_to(target.global_position) > attack_radius:
		state = State.AGGRESSIVE

# Check if the target is outside the deaggro radius and start deaggro timer
func check_deaggro(delta : float) -> void:
	if global_position.distance_to(spawn_point) > deaggro_radius:
		deaggro_timer += delta
		if deaggro_timer >= deaggro_time:
			state = State.RETURNING
			deaggro_timer = 0.0
	else:
		deaggro_timer = 0.0

# Return to spawn point
func return_to_spawn(_delta : float)	-> void:
	var direction : Vector2 = (spawn_point - global_position).normalized() * speed
	move_and_slide()  # Adjust speed as necessary
	if global_position.distance_to(spawn_point) < 10:  # Close enough to spawn point
		state = State.IDLE
