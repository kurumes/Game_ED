extends Node2D
@onready var game_over: Popup = $GameOver
@onready var lives_container: HBoxContainer = $CanvasLayer/LivesContainer
@onready var life_sprite: Texture2D = preload("res://assets/life_counter.png")
@onready var level_manager: Node2D = $LevelManager


func _on_ship_game_over() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().paused = true
	game_over.show()
	print("gameover")


func _on_ship_life_lost() -> void:
	if lives_container.get_child_count() > 0:
		lives_container.get_child(0).queue_free()
