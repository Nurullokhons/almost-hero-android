extends CharacterBody3D

## First playable movement prototype.
## Keyboard controls are temporary; on-screen Android controls come next.

@export var move_speed: float = 5.0
@export var jump_velocity: float = 7.0
@export var gravity: float = 18.0

func _physics_process(delta: float) -> void:
	var direction := 0.0

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction += 1.0

	velocity.x = direction * move_speed
	velocity.z = 0.0

	if not is_on_floor():
		velocity.y -= gravity * delta
	elif (Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)) and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_velocity

	move_and_slide()
