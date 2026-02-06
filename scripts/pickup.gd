extends Node2D


@export var item:Item

func _ready() -> void:
	var instance = item.scene.instantiate()
	add_child(instance)


#This signal has to be connected to the scenes area_2d
func _on_area_2d_body_entered(body : Node) -> void:
	if body.has_method("on_item_picked_up"):
		body.on_item_picked_up(item)
		queue_free()