extends Control
# assigned to main_menu scene
@onready var start_button = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/start_button
@onready var quit_button = $VBoxContainer/MarginContainer/HBoxContainer/quit_button
# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_start_game)
	quit_button.pressed.connect(_quit_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _start_game():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _quit_game():
	get_tree().quit()
