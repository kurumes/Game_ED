class_name Enemy
extends Node2D

@onready var stats_component: StatsComponent = $StatsComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var flash_component: FlashComponent = $FlashComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

@export var direction: float = 1.0
@export var speed: float = 50.0
@export var spawn_point_count: int
@export var fire_rate: float
@export var rotation_direction: float = 1
@export var bullet_speed: float = 1

func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(func(_hitbox):
		flash_component.flash()
	)
	move_component.velocity = Vector2(direction * speed, 0)
	stats_component.no_health.connect(queue_free)
