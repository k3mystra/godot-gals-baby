class_name Exhaust extends AnimatedSprite2D

var activated : bool = false

func add_power(still_pressing : bool):
	play("vroom vroom")
	if still_pressing == true:
		play("continuous vroom vroom")
	
func stop_adding_power():
	play("no vroom vroom")
