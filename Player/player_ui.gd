extends Control
@onready var iron_count = $VBoxContainer/Iron_Container/Iron_Count
@onready var gold_count = $VBoxContainer/Gold_Container/Gold_Count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	INTERACT_MANAGER.connect("resource_collected", _on_resource_collected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_resource_collected(resource_type: String, amount: int) -> void:
	print("Collected resource:", resource_type, "Amount:", amount)
	match resource_type:
		"Iron":
			var current_iron = int(iron_count.text)
			current_iron += amount
			iron_count.text = str(current_iron)
		"Gold":
			var current_gold = int(gold_count.text)
			current_gold += amount
			gold_count.text = str(current_gold)
