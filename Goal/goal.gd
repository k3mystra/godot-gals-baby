class_name Goal extends Node2D

@onready var particle = $CPUParticles2D

#PRELOAD SOUNDS HERE
var win1 = preload("res://sounds/win1.ogg")
var win2 = preload("res://sounds/win2.ogg")
var win3 = preload("res://sounds/win3.ogg")
var win4 = preload("res://sounds/win4.ogg")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("rocket"):
		GlobalSignal.goal_reached.emit()
		var randSound = randi_range(0, 1)
		particle.emitting = true
		match randSound:
			0: play_sound(win1, 1)
			1: play_sound(win2, 1)

func play_sound (stream: AudioStream, pitch: float): # YOU CAN JUST COPY AND PASTE THIS
	var p = AudioStreamPlayer2D.new() # make new audioplayer
	p.stream = stream
	p.pitch_scale = pitch + randf_range(-0.3, 0.3)
	add_child(p) # adds to the world
	p.play() # play first
	p.finished.connect(p.queue_free) # remove itself after finished playing
