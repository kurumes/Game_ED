extends Node

var current_stage: int = 0
var practice: bool = false
var start_frame: int = 0

@onready var stages_lookup = [
	"res://stages/stage_1.tscn",
]
	
func start_stage(stage_number: int) -> void:
	current_stage = stage_number
	get_tree().paused = false
	if(stage_number <= 0):
		get_tree().call_deferred(
		"change_scene_to_file",
		stages_lookup[stage_number]
		)
	else:
		get_tree().call_deferred(
			"change_scene_to_file",
			"res://menu/main_menu.tscn"
		)
	
func next_stage() -> void:
	get_tree().paused = false
	if (current_stage < 1):
		start_stage(current_stage+1)
	else:
		get_tree().call_deferred(
		"change_scene_to_file",
		"res://menu/main_menu.tscn")

func restart_stage() -> void:
	print("restarted")
	current_stage = 0
	start_stage(current_stage)
