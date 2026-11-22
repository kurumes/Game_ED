extends Popup

@onready var next_stage_button: Button = $VBoxContainer/NextStageButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_stage_button.grab_focus.call_deferred()	
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _on_next_stage_button_pressed() -> void:
	if (GlobalManager.practice == true):
		get_tree().call_deferred(
		"change_scene_to_file",
		"res://menu/main_menu.tscn"
		)
	else: GlobalManager.next_stage()
