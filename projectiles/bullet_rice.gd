extends Node2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

@export var speed: int
@export var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(func(_hitbox):
		queue_free()
	)
func _physics_process(delta):
		position += direction * speed * delta
