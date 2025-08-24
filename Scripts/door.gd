extends Node3D
# Assigned to bay_door in ship scene
enum DOOR_STATE {OPEN, CLOSED}
var state = DOOR_STATE.CLOSED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	if state == DOOR_STATE.CLOSED:
		open()
	elif state == DOOR_STATE.OPEN:
		close()

func highlight():
	var panel = $bay_door_panel
	panel.ALBEDO = "white" 
	
func open():
	var animation_player = $AnimationPlayer
	if !animation_player.is_playing():
		animation_player.play("open_bay_door")
		state = DOOR_STATE.OPEN

func close():
	var animation_player = $AnimationPlayer

	if !animation_player.is_playing():
		animation_player.play("close_bay_door")
		state = DOOR_STATE.CLOSED
