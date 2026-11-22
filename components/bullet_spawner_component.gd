class_name BulletSpawnerComponent
extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var tp_area: Area2D = get_node_or_null("TpArea")

enum pattern_type{
	Ring,
	Spread,
}

enum movement_type{
	Up,
	Down,
	Right,
	Left,
	UpRight,
	UpLeft,
	DownRight,
	DownLeft
}

@export_category("Bullet")
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 120

@export_category("Type")
@export var pattern: pattern_type
@export var rng: bool
@export var aimed: bool
@export var radius: int = 1

@export_category("Settings")
@export var enabled: bool = true
@export var spawner_count: int
@export var fire_rate: float

@export var spread_angle: float
@export var random_angle: float

@export var startup_time: float = 0.01

@export_category("Rotation")
@export var base_rotate_speed: float
@export var accelerating_rotation: bool

@export var initial_angular_speed: float
@export var max_angular_speed: float
@export var angular_accel: float
@export var max_accel_rotation: float
@export var min_accel_rotation: float

@export var rotation_direction: int = 1

@export_category("Teleportation")
@export var teleporting: bool
@export var tp_interval: float

@export_category("Circular Movement")
@export var circular_movement: bool
@export var circle_radius: float
@export var circle_speed: float = 5
@export var circular_spiral: bool
@export var min_radius: float
@export var max_radius: float
@export var spiral_speed: float
@export var spiral_direction: int = 1

@export_category("Linear Movement")
@export var linear_movement: bool
@export var move_type: movement_type
@export var move_speed: float
@export var move_time: float
@export var looping_movement: bool


var startup_timer: Timer
var shoot_timer: Timer

var teleport_timer: Timer
var tp_area_center: Vector2

var move_timer: Timer
var move_direction: Vector2

var spawn_points: Node2D

var circle_angle: float
var circle_center: Vector2
var angular_velocity: float


func _ready() -> void:
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = fire_rate
	shoot_timer.timeout.connect(fire_timer_timeout)
	add_child(shoot_timer)
	
	if (linear_movement):
		move_timer = Timer.new()
		move_timer.one_shot = true
		move_timer.wait_time = move_time
		move_timer.timeout.connect(move_timer_timeout)
		add_child(move_timer)
		
		move_timer.start()
	
	if (teleporting):
		tp_area_center = tp_area.global_position
		teleport_timer = Timer.new()
		teleport_timer.wait_time = tp_interval
		teleport_timer.timeout.connect(tp_timer_timeout)
		add_child(teleport_timer)
		teleport_timer.start()

	if (accelerating_rotation):
		angular_velocity = initial_angular_speed * rotation_direction	

	if (circular_movement):
		circle_center = position

	if (enabled):
		start_spawner()

func player_is_alive() -> bool:
	return is_instance_valid(player) and player.is_visible_in_tree()

func start_spawner() -> void:
	#if (startup_time > 0.0):
	startup_timer = Timer.new()
	startup_timer.one_shot = true
	startup_timer.wait_time = startup_time
	startup_timer.timeout.connect(setup_spawner)
	add_child(startup_timer)
	startup_timer.start()
	#else:
		#setup_spawner()

func enable_spawner() -> void:
	enabled = true
	startup_timer.start()
func disable_spawner() -> void:
	enabled = false
	startup_timer.stop()
	shoot_timer.stop()
	
func setup_spawner() -> void:
	if (not enabled):
		return
	
	spawn_points = Node2D.new()
	spawn_points.name = "SpawnPoints"
	add_child(spawn_points)
	
	match (pattern):
		pattern_type.Ring:
			ring_setup()
		pattern_type.Spread:
			spread_setup()
		
	shoot_timer.start()
	update_move_direction()

func fire_timer_timeout() -> void:
	
	match (pattern):
		pattern_type.Ring:
			ring_shoot()
		pattern_type.Spread:
			spread_shoot()

func tp_timer_timeout() -> void:
	teleport_spawner()
	
func move_timer_timeout() -> void:
	if (looping_movement):
		move_direction *= -1
		move_timer.start()
	else:
		linear_movement = false

func update_move_direction() -> void:
	match (move_type):
		movement_type.Up:
			move_direction = Vector2.UP
		movement_type.Down:
			move_direction = Vector2.DOWN
		movement_type.Right:
			move_direction = Vector2.LEFT
		movement_type.Left:
			move_direction = Vector2.RIGHT
			
		movement_type.UpRight:
			move_direction = Vector2(1,-1).normalized()
		movement_type.UpLeft:
			move_direction = Vector2(-1,-1).normalized()
		movement_type.DownRight:
			move_direction = Vector2(1,1).normalized()
		movement_type.DownLeft:
			move_direction = Vector2(-1,1).normalized()
			
func teleport_spawner() -> void:
	var tp_box: CollisionShape2D = tp_area.get_node("CollisionShape2D")
	var shape = tp_box.shape
	
	var half_size = shape.size/2.0
	var random_offset = Vector2(
		randf_range(-half_size.x, half_size.x),
		randf_range(-half_size.y, half_size.y)
	)
	global_position = tp_area_center + random_offset
	
func ring_setup():
	var step: = TAU / spawner_count

	for i in range(spawner_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step*i);
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		spawn_points.add_child(spawn_point)

func ring_shoot():
	
	if aimed and not player_is_alive():
		return

	for s in spawn_points.get_children():

		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.speed = bullet_speed
		bullet.position = s.global_position
		
		var angle_offset = 0
		#if (rng):
			#angle_offset = deg_to_rad(randf_range(-random_angle,random_angle))
			
		bullet.rotation = s.global_rotation + angle_offset
		
		if aimed and player_is_alive():
			bullet.direction = s.global_position.direction_to(player.global_position)
			bullet.rotation = bullet.direction.angle()

func spread_setup():
	for i in range(spawner_count):
		var spawn_point = Node2D.new()
		var angle = 0.0
		if spawner_count > 1:
			angle = deg_to_rad(-spread_angle/2.0) + deg_to_rad(spread_angle)*i/(spawner_count-1)
		var pos = Vector2(radius, 0).rotated(angle);
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		spawn_points.add_child(spawn_point)

func spread_shoot():
	
	if aimed and not player_is_alive():
		return
	
	var direction = Vector2.DOWN
	
	if aimed and player_is_alive():
		direction = global_position.direction_to(player.global_position)
	for s in spawn_points.get_children():
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		
		bullet.speed = bullet_speed
		bullet.position = s.global_position
		
		bullet.direction = direction.rotated(s.rotation)
		
		bullet.rotation = bullet.direction.angle()

func _physics_process(delta: float) -> void:
	if (not is_instance_valid(spawn_points)):
		return
	if (rng == true and not accelerating_rotation):
		var new_rotation = spawn_points.rotation_degrees + base_rotate_speed * rotation_direction * delta * randf_range(2,10)
		spawn_points.rotation_degrees = fmod(new_rotation, 360)
	if (rng == false and not accelerating_rotation):
		var new_rotation = spawn_points.rotation_degrees + base_rotate_speed * rotation_direction * delta * 2
		spawn_points.rotation_degrees = fmod(new_rotation, 360)
		
	if (circular_movement):
		circle_angle += circle_speed * delta
		if (circular_spiral):
			circle_radius += spiral_speed * spiral_direction * delta
			if (circle_radius >= max_radius):
				circle_radius = max_radius
				spiral_direction = -1
			elif (circle_radius <= min_radius):
				circle_radius = min_radius
				spiral_direction = 1
		position = circle_center + Vector2(cos(circle_angle), sin(circle_angle)) * circle_radius
		
	if (accelerating_rotation):
		print("Velocity: ", angular_velocity, " | Rotation: ", spawn_points.rotation_degrees)
			
		angular_velocity += angular_accel * delta
		angular_velocity = clampf(angular_velocity, -max_angular_speed, max_angular_speed)
		
		var new_rotation = spawn_points.rotation_degrees + angular_velocity * rotation_direction * delta
		
		if (new_rotation >= max_accel_rotation):
			new_rotation = max_accel_rotation
			rotation_direction = -1
		elif (new_rotation <= min_accel_rotation):
			new_rotation = min_accel_rotation
			rotation_direction = 1
			
		spawn_points.rotation_degrees = new_rotation
		
	if (linear_movement):
		spawn_points.position += move_direction * move_speed * delta
		
#Não iniciada / parcial / concluída 
#Aprovado / falhou 
