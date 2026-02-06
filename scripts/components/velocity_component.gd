extends Node
class_name VelocityComponent

@export var max_Speed  := 100.0
@export var max_Accel  := 100.0
@export var max_Decel  := 100.0
@export var accelerationCoefficient := 10;

var velocity := Vector2()
var speedMultiplier := 1.0
var accelerationCoefficientMultiplier := 1.0

var calculatedMaxSpeed:float = max_Speed * (1.0 * speedMultiplier)
var speedPercent:float = min(velocity.length() / max_Speed, 1.0)



