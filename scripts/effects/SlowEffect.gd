class_name SlowEffect extends Effect

var duration := 1.0

func apply_effect(target: Node2D) -> void:
	print("Slow " + target.name + " for " + str(duration) + " second");
