extends Node3D


@onready var label = $Label3D
@onready var light = $ItemMesh/OmniLight3D
@onready var mesh_instance: MeshInstance3D = $ItemMesh
@onready var collision_shape: CollisionShape3D = $Item_Static_Body/Item_Collision_Shape
@export var door_leads_to_scene: String
@export var door_leads_to_spawn_point: String

@export var item_index: int
@export_enum("Iron", "Gold", "Door") var item_type: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mat: Material
	print(item_type)
	print(door_leads_to_scene)
	print(door_leads_to_spawn_point)
	match item_type:
		"Iron":
			var iron_mesh = preload("res://Blends/resource_node.obj")
			mesh_instance.mesh = iron_mesh
			_update_collision_from_mesh(iron_mesh)
			mat = preload("res://material/iron.tres")
		"Gold":
			var gold_mesh = preload("res://Blends/resource_node.obj")
			mesh_instance.mesh = gold_mesh
			_update_collision_from_mesh(gold_mesh)
			mat = preload("res://material/gold.tres")
		"Door":
			var door_mesh = preload("res://Blends/door.obj")
			mesh_instance.mesh = door_mesh
			_update_collision_from_mesh(door_mesh)
			mat = preload("res://material/door.tres")
			
	mesh_instance.material_override = mat

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var spawn_point_name: String

func interact(player):
	match item_type:
		"Door":
			SCENE_MANAGER.load_map(door_leads_to_scene, player, door_leads_to_spawn_point)
		"Iron":
			INTERACT_MANAGER.emit_signal("resource_collected", "Iron", 1)
			queue_free()
		"Gold":
			INTERACT_MANAGER.emit_signal("resource_collected", "Gold", 1)
			queue_free()
			
			

func set_item_type(new_type: String):
	item_type = new_type
	
	
	
func _update_collision_from_mesh(mesh: Mesh) -> void:
	if mesh:
		collision_shape.shape = mesh.create_trimesh_shape()
		
func trigger_popup(item, arg):
	UTILS.print_to_dev_console("popup trigger: " + str(item))
	var label = item.get_node("Label3D")
	if label:
		label.visible = arg
		
