extends CharacterBody2D
class_name Enemy

@export var canChase := true
@export var speed := 100
@export var maxRange := 150

enum MobState {IDLE, CHASING, RETREAT, RETURN, ATTACKING, DEATH}
var current_state : MobState
var distance_traveled := 0.0
var startPosition := Vector2.ZERO
var player : Node2D = null

func _ready() -> void:
	current_state = MobState.IDLE
	startPosition = global_position
	if player == null:	
		player = Globals.player

func _physics_process(delta: float) -> void:
		
	if is_instance_valid(player):
		var distance : Vector2 = player.global_position - self.global_position
		var direction : Vector2 = distance.normalized()
		match current_state:
			MobState.IDLE:
				velocity = Vector2.ZERO
			MobState.CHASING:
				if !canChase:
					return
					
				distance_traveled += direction.length();
				# Move toward the player
				if distance_traveled <= maxRange:
					position += direction * speed * delta;
					
					# TODO: if with-in attack range change state
					if canAttack(distance):
						current_state = MobState.ATTACKING
				else:
					current_state = MobState.RETURN
			MobState.RETURN:
				# return to the startPosition
				var direction_to_start :Vector2 = startPosition - global_position
				var distance_to_start :float= direction_to_start.length()
				# A small threshold to prevent jittering around the target
				if distance_to_start > 10: 
					velocity = direction_to_start.normalized() * speed
				else:
					distance_traveled = 0
					current_state = MobState.IDLE
			MobState.ATTACKING:
				# Attack the player
				pass

		move_and_slide()

func TakeDamage(value: int) -> void:
	var comp := $Components/HealthComponent
	if is_instance_valid(comp):
		comp.TakeDamage(value)
	

func canAttack(distance: Vector2) -> bool:
	return distance.length() <= 25

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		current_state = MobState.CHASING

