extends Node2D

@export var player: Node2D

@onready var left_muzzle: Marker2D = $LeftMuzzle
@onready var left_muzzle_2: Marker2D = $LeftMuzzle2
@onready var center_muzzle: Marker2D = $CenterMuzzle
@onready var right_muzzle: Marker2D = $RightMuzzle
@onready var right_muzzle_2: Marker2D = $RightMuzzle2

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var move_component: MoveComponent = $MoveComponent
@onready var flame_animated_sprite: AnimatedSprite2D = $FlameAnimatedSprite
@onready var respawn_timer: Timer = $RespawnTimer
@onready var iframe_timer: Timer = $iframeTimer

@export var stats_component: StatsComponent
@export var destroy_effect_spawner_component: SpawnerComponent
@export var lives: int = 3

signal life_lost
signal game_over
signal gained_life

func _ready() -> void:
	fire_rate_timer.one_shot = true

func fire_lasers() -> void:
	if player.is_visible_in_tree():
				
		spawner_component.spawn(left_muzzle.global_position)
		spawner_component.spawn(left_muzzle_2.global_position)
		spawner_component.spawn(center_muzzle.global_position)
		spawner_component.spawn(right_muzzle.global_position)
		spawner_component.spawn(right_muzzle_2.global_position)
		fire_rate_timer.start()

func shooting_input(event) -> void:
	if (event.is_action_pressed("shoot") && fire_rate_timer.is_stopped()):
		fire_lasers()

func _physics_process(_delta: float) -> void:
	shooting_input(Input)
	animate_the_ship()

func animate_the_ship() -> void: 
	if move_component.velocity.x < 0:
		animated_sprite_2d.play("bank_left")
		flame_animated_sprite.play("bank_left")
		
	elif move_component.velocity.x > 0:
		animated_sprite_2d.play("bank_right")
		flame_animated_sprite.play("bank_right")
		
	else:
		animated_sprite_2d.play("center")
		flame_animated_sprite.play("center")

func _on_stats_component_no_health() -> void:
	destroy_effect_spawner_component.spawn(player.global_position)
	lives -= 1
	life_lost.emit()
	hide()
	get_node("HurtboxComponent").set_deferred("monitorable", false)
	respawn_timer.start(1)
	if (lives <= 0):
		game_over.emit()
		print("gameover")

func _on_respawn_timer_timeout() -> void:
	if (lives > 0):
		iframe_timer.start(1)
		show()
		get_node("HurtboxComponent").set_deferred("monitorable", true)
		player.set_global_position(Vector2(80,216))

func _on_iframe_timer_timeout() -> void:
	$StatsComponent.health = 1
	
func gain_life() -> void:
	lives += 1
	gained_life.emit()
