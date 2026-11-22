class_name MoveInputComponent
extends Node

@export var move_stats: MoveStats
@export var move_component: MoveComponent

func _physics_process(_delta: float) -> void:
	var input_vector  = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	move_component.velocity = input_vector * move_stats.speed
	if (Input.is_action_pressed("focus")):
		move_component.velocity = (input_vector * move_stats.speed)*0.60
	
	
