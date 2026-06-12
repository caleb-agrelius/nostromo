extends Node

signal resource_collected(resource_type: String, amount: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_interact(item: Node3D, player: Node3D):
	item.interact(player)
