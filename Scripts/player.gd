extends CharacterBody3D
# assigned to player scene
signal interact
signal swap_scene


@export var mouse_sensitivity = 0.0008
@export var speed = 5
@onready var player_camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
@onready var game_node = get_tree().get_root().get_node("game")

var collision_object: Object = null
var prev_collision_object: Object = null

var highlight_overlay : Material = preload("res://materials/interactable_highlight.tres")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta):
	var direction = Vector3.ZERO
	var door_state = 0
	
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	direction = direction.normalized()
	var movement = transform.basis * direction
	
	velocity.x = movement.x * speed
	velocity.z = movement.z * speed
	velocity.y -= 9.8 * delta
	if raycast.is_colliding():
		collision_object = raycast.get_collider()

		if collision_object:
			for child in collision_object.get_children():
				if child.is_in_group("interactable"):
					collision_object.get_parent().set_material_overlay(highlight_overlay)
					if Input.is_action_just_pressed("interact"):
						if child.is_in_group("door"):
							var parentDoor = collision_object.get_parent()
							interact.emit(parentDoor)
						elif child.is_in_group("computer"):
							swap_scene.emit("computer_scene")
					prev_collision_object = collision_object
	
	if prev_collision_object and raycast.is_colliding():
		if prev_collision_object != raycast.get_collider():
			prev_collision_object.get_parent().set_material_overlay(null)
			prev_collision_object = null
			
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		player_camera.rotate_x(-event.relative.y * mouse_sensitivity)
		player_camera.rotation.x = clampf(player_camera.rotation.x, -deg_to_rad(60), deg_to_rad(60))
