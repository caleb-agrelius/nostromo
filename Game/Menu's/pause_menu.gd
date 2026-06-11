extends Control

@onready var resume_button: Button = $Resume_Button
@onready var quit_button: Button = $Quit_Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_button.process_mode = Node.PROCESS_MODE_ALWAYS
	quit_button.process_mode = Node.PROCESS_MODE_ALWAYS

	resume_button.pressed.connect(close_pause_menu)
	quit_button.pressed.connect(quit_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if get_tree().paused:
			close_pause_menu()
		else:
			open_pause_menu()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("clicking")

func open_pause_menu():
	print("pausing")
	get_tree().paused = true;
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	self.show();
	
func close_pause_menu():
	print("unpausing")
	print("closing pause menu")
	get_tree().set_pause(false)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	self.hide();

func quit_game():
	get_tree().quit()
