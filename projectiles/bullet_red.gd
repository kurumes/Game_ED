extends Node2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

@export var speed: int
@export var direction: Vector2 = Vector2.DOWN

var despawn_multiplier = 2

func outside_screen() -> bool:
	var screen_rect = get_viewport_rect()
	var margin = screen_rect.size * despawn_multiplier
	screen_rect = screen_rect.grow_individual(margin.x,margin.y,margin.x,margin.y)
	
	return not screen_rect.has_point(global_position)

func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(func(_hitbox):
		queue_free()
	)
	if (outside_screen()):
		queue_free()
	
func _physics_process(delta):
	position += transform.x * speed * delta
	if (outside_screen()):
		queue_free()
