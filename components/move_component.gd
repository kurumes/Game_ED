class_name MoveComponent
extends Node

@export var actor: Node2D
@export var velocity: Vector2
@export var turn_rate: float = 0.0

func _physics_process(delta: float) -> void:
	velocity = velocity.rotated(turn_rate*delta)
	actor.global_position += velocity * delta
