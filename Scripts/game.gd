extends Node3D

#player
@onready var player_scene: PackedScene = load("res://Scenes/player.tscn")
@onready var player_character: Node3D
@onready var direction_indicator: Node3D
@onready var camera: Node3D
@onready var player: Node3D

#map
@onready var open_world: PackedScene = load("res://Scenes/open_world.tscn")
@onready var hideout: PackedScene = load("res://Scenes/hideout_interior.tscn")

#menu
@onready var main_menu: Control = $CanvasLayer/Main_Menu
@onready var start_button: Button = $CanvasLayer/Main_Menu/start
@onready var game_start: bool = false

#items
@onready var mesh_res: Mesh = preload("res://Assets/resource_node.obj")
@onready var resource_node_shader: Shader = preload("res://shaders/resource_node.gdshader")
@onready var item_node_scene: PackedScene = preload("res://Scenes/item.tscn")

var virtual_cursor := Vector2.ZERO
var i = 0;
var resource_node_cap = 15;
var resource_node_count = 0;

func add_player():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = player_scene.instantiate()
	player.position = Vector3(0, 1, 0)
	get_tree().root.add_child(player)
	player_character = player.get_node("Player_Character_Body")
	camera = player_character.get_node("Player_Camera")
	direction_indicator = player_character.get_node("Direction_Indicator_Gimbal")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SCENE_MANAGER.game = self
	start_button.pressed.connect(start_game)
	virtual_cursor = get_viewport().size * 0.5
	
func start_game():
	game_start = true
	add_player()
	SCENE_MANAGER.load_map("hideout", player, "inside_hideout")
	spawn_resource_nodes()
	$CanvasLayer/Main_Menu.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_start:
		player_direction_indicator_manager()
		
func get_map_container() -> Node3D:
	return get_node("Map_Container")
	
func spawn_resource_nodes():
	var map_mesh_size = SCENE_MANAGER.open_world_instantiated.get_node("Map_Mesh").mesh.size
	var half_x_map = map_mesh_size.x / 2
	var half_z_map = map_mesh_size.y / 2

	for resource_node_count in resource_node_cap:
		var item_instantiated = item_node_scene.instantiate()
		var x_coord = randf_range(-half_x_map, half_x_map)
		var z_coord = randf_range(-half_z_map, half_z_map)
		item_instantiated.position = Vector3(x_coord, 0, z_coord)
		var random_type: String = ["Iron", "Gold"].pick_random()
		item_instantiated.item_type = random_type
		SCENE_MANAGER.open_world_instantiated.add_child(item_instantiated)
		var item_label = item_instantiated.get_node("Label3D")
		item_label.text += random_type
		
	
	
func player_direction_indicator_manager():
	var origin = camera.project_ray_origin(virtual_cursor)
	var direction = camera.project_ray_normal(virtual_cursor)

	# Project onto a plane at the indicator's height
	var plane_y = direction_indicator.global_position.y
	var plane = Plane(Vector3.UP, plane_y)

	var hit = plane.intersects_ray(origin, direction)
	if hit:
		direction_indicator.look_at(hit, Vector3.UP)
			

func _input(event):
	var direction = Vector3.ZERO
	if event is InputEventMouseMotion:
		virtual_cursor += event.relative
		var size = get_viewport().size
		
	
	if Input.is_action_just_pressed("open_dev_console"):
		UTILS.open_dev_console();
		print("dev console opened")
