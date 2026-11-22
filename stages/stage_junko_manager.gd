extends Node2D

@onready var ship: Node2D = $"../Ship"
@onready var stage_clear: Popup = $"../StageClear"


# START FROM FRAME
func _ready() -> void:
	print("Stage JUNKO loaded")
	
func stage_cleared() -> void:
	print("Stage 2 cleared")
	get_tree().paused = true
	stage_clear.show()

func _on_junko_boss_dead() -> void:
	stage_cleared()
