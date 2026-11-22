extends Node2D

@onready var stats_component: StatsComponent = $StatsComponent

@onready var purple: BulletSpawnerComponent = $Purple
@onready var purple_2: BulletSpawnerComponent = $Purple2

@onready var blue: BulletSpawnerComponent = $Blue
@onready var blue_2: BulletSpawnerComponent = $Blue2

@onready var rice: BulletSpawnerComponent = $Rice
@onready var rice_2: BulletSpawnerComponent = $Rice2

@export var working: bool = true

var hp: int = 940
signal boss_dead

var queue: PhaseQueue



func _ready() -> void:
	
	if (!working):
		process_mode = Node.PROCESS_MODE_DISABLED
	queue=PhaseQueue.new()
	
	queue.enqueue(590, 2)
	queue.enqueue(350, 3)
	queue.enqueue(120, 4)
	
	stats_component.health = hp
	
	purple.disable_spawner()
	purple_2.disable_spawner()
	
	blue.disable_spawner()
	blue_2.disable_spawner()
	
	rice.disable_spawner()
	rice_2.disable_spawner()

func _on_stats_component_no_health() -> void:
	print("DEAD")
	boss_dead.emit()
	get_tree().call_group("bullets", "queue_free")

func _on_stats_component_health_changed() -> void:
	print("health left: ", stats_component.health)
	
	if (queue.isEmpty()):
		return
	
	if (stats_component.health <= queue.peek_hp()):
		var next_phase: Phase = queue.dequeue()
		match next_phase.phase_id:
			2:
				print("PHASE 2")
				purple.enable_spawner()
				purple_2.enable_spawner()
			3:
				print("PHASE 3")
				blue.enable_spawner()
				blue_2.enable_spawner()
			4:
				print("PHASE 4")
				rice.enable_spawner()
				rice_2.enable_spawner()
