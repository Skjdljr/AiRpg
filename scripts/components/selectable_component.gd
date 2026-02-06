extends Node2D
class_name selectable_component
var canBeSelected := false

func _ready() -> void:
	if owner != null :
		owner.connect("mouse_entered", _on_mouse_entered)
		owner.connect("mouse_exited", _on_mouse_exited)

func _on_mouse_exited() -> void:
	canBeSelected = false

func _on_mouse_entered() -> void:
	canBeSelected = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("-----")
		var mouse_event : InputEventMouseButton = event as InputEventMouseButton
		if canBeSelected:
			print(1)
			if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.is_pressed():
				if Input.is_action_just_pressed("selection"):
					Globals.selectTarget(self.owner as CharacterBody2D)
		else:
			print(2)
			if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.is_pressed():
				if Input.is_action_just_pressed("selection"):
					Globals.deSelectTarget()
	
