extends Node


@onready var dev_console_overlay = load("res://Scenes/dev_console.tscn")
@onready var dev_console_instantiated = dev_console_overlay.instantiate();
@onready var interactables_list = dev_console_instantiated.get_node("Console_Top_Container/Interactables_Container/Interactables_List")


var dev_console_open = false

func open_dev_console():
	if dev_console_open == false:
		dev_console_open = true
		print("util function successfully called")
		get_tree().root.add_child(dev_console_instantiated)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		print_to_dev_console("console opened")
		dev_console_instantiated.show();
	elif dev_console_open == true:
		dev_console_open = false
		print("closing dev console")
		get_tree().root.remove_child(dev_console_instantiated)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func print_to_dev_console(msg):
	var dev_console_text_label = dev_console_instantiated.get_node("Console_Top_Container/Console_Container/Console_Text");
	dev_console_text_label.text += "\n"
	dev_console_text_label.text += msg;
	

func update_interactables(item, method):
	if method == "add":
		item.item_index = interactables_list.add_item(item.name)
	if method == "remove":
		interactables_list.remove_item(item.item_index)

func get_interactable(index):
	return interactables_list.get_item_metadata(index)
