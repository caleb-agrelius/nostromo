extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var target_position: Vector3
var landed: bool = false
var speed: float = 2.0

func _physics_process(delta):
	if landed:
		return
	var direction = (target_position - global_transform.origin).normalized()
	var distance = global_transform.origin.distance_to(target_position)

	if distance > 0.1:
		linear_velocity = direction * speed
	else:
		landed = true
		linear_velocity = Vector3.ZERO
		self.freeze = true
		self.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
