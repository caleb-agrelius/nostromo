extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var player_body := $Player_Body
@onready var player_camera := $Player_Camera
@onready var anim := $Player_Body/Skeleton3D/AnimationPlayer
@onready var player_ui = load("res://Player/player_ui.tscn")
@onready var instantiated_player_ui = player_ui.instantiate()
@onready var interactables = [];
var current_interact_item: Node3D

func _ready() -> void:
	get_tree().root.add_child(instantiated_player_ui)

func _get_interactable_from_body(body: Node) -> Node3D:
	var node: Node = body
	while node:
		if node.is_in_group("Interactable"):
			return node
		node = node.get_parent()
	return null

func _on_player_interact_detection_body_entered(body: Node3D) -> void:
	print("entered vicinity of: " + str(body))
	var interactable = _get_interactable_from_body(body)
	if interactable:
		current_interact_item = interactable

func _on_player_interact_detection_body_exited(body: Node3D) -> void:
	var interactable = _get_interactable_from_body(body)
	if interactable and current_interact_item == interactable:
		current_interact_item = null


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("interact"):
		if current_interact_item:
			INTERACT_MANAGER.handle_interact(current_interact_item, self)
		else:
			print("No current interact item")
	var input_dir := Input.get_vector("left", "right", "back", "forward")
	var raw_direction := Vector3(input_dir.x, 0, -input_dir.y)
	var direction := (global_transform.basis * raw_direction).normalized()
	if Input.is_action_pressed("shift"):
		SPEED = 10.0
	else:
		SPEED = 5.0
	if raw_direction != Vector3.ZERO:
		anim.play("run")
		player_body.look_at(player_body.global_position + direction, Vector3.UP)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		anim.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
