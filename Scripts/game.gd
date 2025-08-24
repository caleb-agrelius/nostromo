extends Node3D
var computer_scene = preload("res://Scenes/computer_screen.tscn")
var dev_console = preload("res://Scenes/dev_console.tscn")
var dev_console_instance: Node = null
var computer_scene_instance: Node
var player: Node = null
var game_scene: Node
var console_open: bool

func _ready():
	game_scene = get_tree().current_scene
	console_open = false
	var ship = $ship
	player = $player
	player.interact.connect(_on_player_interact)
	player.swap_scene.connect(_on_swap_scene)
	
func _process(delta):
	if player:
		var data = player.collision_object
		if Input.is_action_just_pressed("open_console"):
			_open_tilda_console(data)
		
		if console_open and dev_console_instance:
			var label = dev_console_instance.get_node("dev_console/dev_label")
			if label:
				var obj_collided = player.collision_object
				var info = "Collided Object: "
				if obj_collided != null:
					info += str(obj_collided.name)
				else:
					info += str(obj_collided)
				info += "\nFPS: "
				info += str(Engine.get_frames_per_second())
				if obj_collided != null:
					info += "\nWith Parent: "
					info += str(obj_collided.get_parent().name)
					info += "\nWith Tree: \n"
					info += obj_collided.get_parent().get_tree_string_pretty()
					label.text = info
				else:
					label.text = ""
	

func _on_player_interact(target):
	if target:
		var interactable_node = find_nearest_interact_method(target)
		if interactable_node:
			interactable_node.interact()

func _on_swap_scene(target_scene):
	match target_scene:
		"computer_scene":
			_show_computer_scene()
		"game":
			_return_to_game()
		"Map1", "Map2":
			_load_map_scene(target_scene)
		_:
			print("unknown_scene: ", target_scene)

func _show_computer_scene() -> void:
	game_scene.visible = false
	game_scene.set_process(false)
	
	computer_scene_instance = computer_scene.instantiate()
	computer_scene_instance.swap_scene.connect(_on_swap_scene)
	
	get_tree().root.add_child(computer_scene_instance)
	get_tree().current_scene = computer_scene_instance


func _return_to_game() -> void:
	if computer_scene_instance:
		get_tree().root.remove_child(computer_scene_instance)
		computer_scene_instance.queue_free()
		computer_scene_instance = null
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	game_scene.visible = true
	game_scene.set_process(true)
	get_tree().current_scene = game_scene


func _load_map_scene(map_id: String) -> void:
	var scene_path = "res://Scenes/%s.tscn" % map_id
	if ResourceLoader.exists(scene_path):
		var map_scene = load(scene_path).instantiate()
		get_tree().root.add_child(map_scene)
	else:
		print("map scene not found")

func find_nearest_interact_method(node):
	var current = node
	while current:
		if current.has_method("interact"):
			return current
		current = current.get_parent()
	return null

func _open_tilda_console(data):
	if dev_console_instance == null:
		dev_console_instance = dev_console.instantiate()
		add_child(dev_console_instance)

	var label = dev_console_instance.get_node("dev_console/dev_label")
	console_open = !console_open
	dev_console_instance.visible = console_open
	if label:
		label.text = str(data)
