extends Node

var player : Node2D = null
var current_target : CharacterBody2D = null
var orig_modulate : Color
var original_material : Material
var shader_material : ShaderMaterial
var previousTargetIndex :			= 0
var currentTargetIndex := 0

@export var shader_material_path: String = "res://shaders/outline.tres"

func _ready() -> void:
	shader_material = load(shader_material_path) as ShaderMaterial

# TODO: make a select closet and a select next.
# use those functions in the tabSelection if we have a closest then get next.

# select the closest enemy
func _selectClosestTarget(location: Vector2, enemies : Array[Node]) -> void:
	var closest : CharacterBody2D = find_closest_enemy(location, enemies)
	selectTarget(closest)

# apply the materials to the selected character	
# NOTE ** you should use selectTarget
func _set_selected(selected: bool, target:CharacterBody2D) -> void:
	if target != null and target.has_node("AnimatedSprite2D"):
		var sprite : AnimatedSprite2D = target.get_node("AnimatedSprite2D")
		if selected:
			# Apply the ShaderMaterial
			sprite.material = shader_material.duplicate(true)
		else:
			# Reapply the original material
			sprite.material = original_material

## find the next enemy
func find_next_enemy(enemies :Array[Node]) -> CharacterBody2D:
	if enemies.size() == 0:
		return null
	
	previousTargetIndex = currentTargetIndex;
	# Increment the current enemy index
	currentTargetIndex += 1
	
	# Wrap around if the index exceeds the number of enemies
	if currentTargetIndex >= enemies.size():
		currentTargetIndex = 0
	
	# select the current
	var enemy : CharacterBody2D = enemies[currentTargetIndex]
	
	return enemy

# select the closest or next if closest is already selected
func selectNextTarget(location: Vector2, enemies :Array[Node] ) -> void:
	if current_target == null:
		_selectClosestTarget(location, enemies)
		return
	var next : CharacterBody2D = find_next_enemy(enemies)
	if (next == current_target):
		next = find_next_enemy(enemies)
	if next != null:
		selectTarget(next)

func find_closest_enemy(position : Vector2 , enemies: Array[Node]) -> CharacterBody2D:
	var closest_enemy: CharacterBody2D = null
	var min_distance : float = INF
	
	for enemy : CharacterBody2D in enemies:
		var distance : float = position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy
	
	return closest_enemy

## This is a way to select the object/character and highlight it
func selectTarget(newTarget:CharacterBody2D) -> void:
	if (current_target != null):
		_set_selected(false, current_target)
	if (newTarget != null):
		_set_selected(true, newTarget)
	current_target = newTarget
	print("selected target name: " + newTarget.get_name())

func deSelectTarget() -> void:
	if current_target != null and current_target.has_node("AnimatedSprite2D"):
		var sprite : AnimatedSprite2D = current_target.get_node("AnimatedSprite2D")
		sprite.material = original_material
		current_target = null
