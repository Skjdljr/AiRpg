class_name RootEffect extends Effect

@export var root_duration := 1.0
#@export var target := Node2D

var timer := Timer.new()

func _ready() -> void:
	timer.wait_time = root_duration
	timer.one_shot = true
#	apply_effect(target)
	timer.start()
#	timer.connect("timeout", self, "on_timeout")
	

func apply_effect(target: Node2D) -> void:
	print("Root " + target.name);
	if target.has_method("setCanMove"):
		target.setCanMove(false)

func on_timeout() -> void:
	print("Root had ended!");
#	if target.has_method("setCanMove"):
#		target.setCanMove(true)
#	queue_free()


