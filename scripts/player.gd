extends CharacterBody2D

# Character info
var character_class := "Mage"

# Movement
@export var move_speed := 100.0

# Base stats (set by CharacterStats)
@export var max_hp := 80.0
@export var max_mana := 150.0
@export var spell_damage := 20.0
var current_hp := 0.0

# Mage Skills
@export var skill1_cooldown_max := 3.0  # Direct damage projectile
@export var skill1_mana_cost := 30.0
@export var skill1_damage := 25.0

@export var skill2_cooldown_max := 5.0  # AOE damage burst
@export var skill2_mana_cost := 50.0
@export var skill2_damage := 30.0
@export var skill2_radius := 120.0

var skill1_cooldown := 0.0
var skill2_cooldown := 0.0

# References
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
var health_component : HealthComponent = null
var mana_component : ManaComponent = null
var projectile_scene: PackedScene = preload("res://scenes/directSpell.tscn")

func _ready() -> void:
	Globals.player = self
	health_component = $Components/HealthComponent
	mana_component = $Components/ManaComponent
	
	if health_component:
		health_component.SetMaxHealth(int(max_hp))
		health_component.SetHealth(int(max_hp))
	
	if mana_component:
		mana_component.set_max_mana(max_mana)
		mana_component.restore_mana()
	
	# Apply class stats
	if Globals and Globals.character_stats:
		Globals.character_stats.select_class("Mage")

func _physics_process(delta: float) -> void:
	handle_input()
	handle_movement(delta)
	handle_skills(delta)
	
func handle_input() -> void:
	# Skill 1: Direct damage projectile (Q)
	if Input.is_action_just_pressed("ui_select") and skill1_cooldown <= 0:
		cast_skill_1()
	
	# Skill 2: AOE damage burst (E)
	if Input.is_action_just_pressed("jump") and skill2_cooldown <= 0:
		cast_skill_2()
	
	# Target selection (Tab)
	if Input.is_action_just_pressed("next"):
		Globals.selectNextTarget(global_position, get_tree().get_nodes_in_group("enemy"))

func handle_movement(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * move_speed
	move_and_slide()
	update_animations(direction)

func update_animations(direction: Vector2) -> void:
	# Simple animation handling
	if direction.length() > 0:
		if direction.x > 0:
			animator.play("walk_right")
		elif direction.x < 0:
			animator.play("walk_left")
		else:
			if direction.y != 0:
				animator.play("walk_right")

func handle_skills(delta: float) -> void:
	# Update cooldowns
	if skill1_cooldown > 0:
		skill1_cooldown -= delta
	if skill2_cooldown > 0:
		skill2_cooldown -= delta

func cast_skill_1() -> void:
	"""Direct damage projectile - costs mana, has cooldown"""
	# Check mana
	if not mana_component or not mana_component.has_mana(skill1_mana_cost):
		print("Not enough mana for Skill 1!")
		return
	
	# Use mana
	mana_component.use_mana(skill1_mana_cost)
	skill1_cooldown = skill1_cooldown_max
	
	print("Skill 1: Fire projectile! (Damage: %d, Mana cost: %.0f)" % [skill1_damage, skill1_mana_cost])
	
	# Get nearest enemy to target
	var target = find_nearest_enemy()
	if not target:
		print("No target found!")
		return
	
	# Spawn projectile
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		projectile.position = global_position
		projectile.set_Target(target)
		projectile.speed = 800  # Faster projectile
		get_parent().add_child(projectile)

func cast_skill_2() -> void:
	"""AOE damage burst around player - costs mana, has cooldown"""
	# Check mana
	if not mana_component or not mana_component.has_mana(skill2_mana_cost):
		print("Not enough mana for Skill 2!")
		return
	
	# Use mana
	mana_component.use_mana(skill2_mana_cost)
	skill2_cooldown = skill2_cooldown_max
	
	print("Skill 2: AOE Burst! (Damage: %d, Mana cost: %.0f)" % [skill2_damage, skill2_mana_cost])
	
	# Get all enemies in radius
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= skill2_radius:
			if enemy.has_method("TakeDamage"):
				enemy.TakeDamage(skill2_damage)
	
	# TODO: Add visual effect (expanding circle from player)

func find_nearest_enemy() -> Node2D:
	"""Find closest enemy to player"""
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest = null
	var nearest_distance = INF
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = enemy
	
	return nearest

func restore_resources() -> void:
	"""Restore health and mana (called on floor completion)"""
	if health_component:
		health_component.SetHealth(int(health_component.GetMaxHealth()))
	if mana_component:
		mana_component.restore_mana()
