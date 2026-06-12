extends Node

#maps
var open_world_scene = load("res://Scenes/open_world.tscn")
var hideout_scene = load("res://Scenes/hideout_interior.tscn")
var map_container: Node3D
var open_world_instantiated: Node3D
var hideout_instantiated: Node3D

func _ready() -> void:
	pass
		
var game:
	set(value):
		if value != null:
			game = value
			run_setup()


func run_setup():
	map_container = game.get_map_container()
	print(str(map_container))
	open_world_instantiated = open_world_scene.instantiate()
	hideout_instantiated = hideout_scene.instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_map(map_name: String, player: Node3D, spawn_point_name) -> void:
	if map_container:
		print("map container: " + str(map_container))
		if map_container.get_child_count() == 0:
			match map_name:
				"open_world":
					map_container.add_child(open_world_instantiated)
				"hideout":
					map_container.add_child(hideout_instantiated)
		else:
			print("no map container found")
			map_container.remove_child(map_container.get_child(0))
			load_map(map_name, player, spawn_point_name)
			
		spawn_player_at_position(player, spawn_point_name)
	

func spawn_player_at_position(player, spawn_point_name: String):
	var spawn_point = map_container.get_node_or_null("Spawn_Point")

	var spawn_pos: Vector3
	if spawn_point and spawn_point.spawn_id == spawn_point_name:
		spawn_pos = spawn_point.global_position
	else:
		print("WARNING: Spawn point not found, using default")
		spawn_pos = Vector3(0, 1, 0)

	# Move player
	var body = player.get_node_or_null("Player_Character_Body")
	if body:
		body.set_physics_process(false)
		body.velocity = Vector3.ZERO
		body.global_position = spawn_pos
		await get_tree().physics_frame
		body.set_physics_process(true)
	else:
		player.global_position = spawn_pos
