extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

var fastExit = 0

func _ready() -> void:
	get_tree().paused = false
	GlobalManager.practice = false
	GlobalManager.current_stage = 0
	GlobalManager.start_frame = 0
	start_button.grab_focus.call_deferred()
	fastExit = 0

func _input(event) -> void:
	if (event.is_action_pressed("ui_exit") && fastExit == 0):
		exit_button.grab_focus.call_deferred()
	if (event.is_action_pressed("ui_exit") && fastExit == 1):
		_on_exit_button_pressed()

func _on_exit_button_focus_entered() -> void:
	fastExit = 1

func _on_exit_button_focus_exited() -> void:
	fastExit = 0

func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://stages/stage_1.tscn")
