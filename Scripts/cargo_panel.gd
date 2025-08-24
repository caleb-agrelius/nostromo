extends Node3D
# Assigned to bay_door in ship scene
enum CARGO_DOOR_STATE {OPEN, CLOSED}
var state = CARGO_DOOR_STATE.CLOSED
var crate_scene = preload("res://Scenes/crate.tscn")
var landing_pad_01: Node = null
var landing_pad_02: Node = null
@onready var crates_to_pickup_label: Node = $ship_cargo_panel_screen_002/crates_to_pickup

func _ready():
	landing_pad_01 = $landing_pad_01
	landing_pad_02 = $landing_pad_02

func _process(delta):
	crates_to_pickup_label.text = str(GameState.crates_remaining)
	
func interact():
	if state == CARGO_DOOR_STATE.CLOSED:
		open()
	elif state == CARGO_DOOR_STATE.OPEN:
		close()

func highlight():
	var panel = $ship_cargo_panel_door
	panel.ALBEDO = "white" 
	
func open():
	var animation_player = $AnimationPlayer
	if !animation_player.is_playing():
		var crate_instance = crate_scene.instantiate()

		var door_position = $ship_cargo_panel_door.global_transform.origin
		var spawn_position = door_position + Vector3(0, .6, -1)
		crate_instance.global_transform.origin = spawn_position
		
		var pad = null
		if !landing_pad_01.has_meta("occupied") or !landing_pad_01.get_meta("occupied"):
			pad = landing_pad_01
		elif !landing_pad_02.has_meta("occupied") or !landing_pad_02.get_meta("occupied"):
			pad = landing_pad_02
			
		if pad:
			pad.set_meta("occupied", true)
			print(pad.global_transform)
			crate_instance.target_position = pad.global_transform.origin + Vector3(0, .3, 0)
			add_child(crate_instance)
			animation_player.play("open_cargo_door")
			state = CARGO_DOOR_STATE.OPEN
		else:
			print("no landing pads", pad)

func close():
	var animation_player = $AnimationPlayer
	if !animation_player.is_playing():
		animation_player.play("close_cargo_door")
		state = CARGO_DOOR_STATE.CLOSED
