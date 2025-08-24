extends Control
signal swap_scene

var map_buttons: Array = []
@onready var exit_button = $Exit

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	exit_button.pressed.connect(_exit_screen_btn)
	
	var Map_Selection = $TabContainer/Map_Selection/map_button_container
	for button in Map_Selection.get_children():
		map_buttons.append(button)
		button.pressed.connect(_map_button_press.bind(button.name))
	var player_credits = $TabContainer/General/player_credits
	player_credits.text += str(GameState.player_credits)
	var crates_on_ship = $TabContainer/General/crates_on_ships
	crates_on_ship.text += str(GameState.crates_on_ship)

func _exit_screen_btn():
	swap_scene.emit("game")

func _map_button_press(map):
	swap_scene.emit(map)

func _process(delta: float) -> void:
	pass
