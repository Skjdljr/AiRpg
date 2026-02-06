extends CharacterBody2D

@export var speed := 50
@onready var player : AnimationPlayer = $AnimationPlayer
@onready var sprite  : Sprite2D = $Sprite2D
@export var spell := Spell

func _ready() -> void:
	Globals.player = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	handleInput()
	handleMovement(delta)
	
func handleInput() -> void:
	if Input.is_action_just_pressed("next"):
		print("tab pressed")
		Globals.selectNextTarget(global_position, get_tree().get_nodes_in_group("enemy"))

func handleMovement(delta: float) -> void:
	var direction := Input.get_vector("left","right","up", "down")
	velocity = direction * speed
	move_and_slide()
	handleAnims(direction)
	
	
func handleAnims(direction: Vector2) -> void:
	# animate character
	if Input.is_action_just_pressed("jump"):
		player.play("jump")
	else:
		# Horizontal movement
		if direction.x != 0:
			if direction.x > 0:
				player.play("walk_right")
			else:
				player.play("walk_left")
		else:
			# Vertical movement
			if direction.y != 0:
				if %Sprite2D.flip_h:
					player.play("walk_left")
				else:
					player.play("walk_right")
