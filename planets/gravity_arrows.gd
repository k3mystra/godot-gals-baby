class_name GravityArrows extends Node2D

var speed: float:
	get:
		return $Arrow.speed_scale
	set(value):
		$Arrow.speed_scale = value
