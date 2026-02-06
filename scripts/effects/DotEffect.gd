class_name DotEffect extends Effect

@export var totalTime := 1.0
@export var ammountOfTicks:int = 2
@export var isOneShot := true

var timer := Timer.new()
var count:int = 0

# Todo: need to create a way to have it do damage on an interval

func ready() -> void:
	if ammountOfTicks <= 0:
		ammountOfTicks = 1

	timer.wait_time = totalTime / ammountOfTicks
	timer.one_shot = isOneShot
	#timer.process_callback()
	timer.start()
	#timer.connect("timeout", self, "on_timeout")

func apply_effect(target: Node2D) -> void:
	print("target" + target.name)
	# needs a spell details or something to fire!
	pass

func suspend_effect() -> void:
	timer.paused = true
	
func resume_effect() -> void:
	timer.paused = false

func on_timeout() -> void:
	if count < ammountOfTicks:
		#apply_effect(target)
		timer.start()

	count += 1
