extends Popup

var fastExit = 0

@onready var exit_button: Button = $VBoxContainer/ExitButton
@onready var menu_button: Button = $VBoxContainer/MenuButton
@onready var restart_button: Button = $VBoxContainer/RestartButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	restart_button.grab_focus.call_deferred()
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
	get_tree().paused = false
	get_tree().quit()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().call_deferred(
	"change_scene_to_file",
	"res://menu/main_menu.tscn"
	)

func _on_restart_button_pressed() -> void:
	GlobalManager.start_stage(0)
