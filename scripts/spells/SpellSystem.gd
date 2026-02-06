extends Node2D

var direct_spell_scene : PackedScene = preload("res://scenes/directSpell.tscn")
var target :Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("fire"):
		tryCastSpell()

func tryCastSpell() -> void:
	if is_instance_valid(Globals.current_target):
		if facingTarget(Globals.current_target):
			# TODO: need to check spell range
			# TODO: need to check mana
			cast()
		else:
			print("Can't cast spell, target is behind!")

func cast() -> void:
	var new_spell : Node = direct_spell_scene.instantiate()

	new_spell.set_Target(Globals.current_target)
	new_spell.global_position = %Marker2D.global_position
	new_spell.global_rotation = %Marker2D.global_rotation
	
	%Marker2D.add_child(new_spell)
		
func facingTarget(target : Node2D) -> bool:
	 # Get direction to target
	var direction_to_target := global_position.direction_to(target.global_position)

	# Check if facing left or right
	if %Sprite2D.flip_h:
		# Facing left (negative x direction)
		return direction_to_target.x < 0
	else:
		# Facing right (positive x direction)
		return direction_to_target.x > 0
