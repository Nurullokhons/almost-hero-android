extends CharacterBody3D

## Lightweight procedural hero prototype. All geometry is built from simple meshes
## so the first version stays small and runs on entry-level Android devices.

@export var move_speed: float = 5.0
@export var jump_velocity: float = 7.0
@export var gravity: float = 18.0
@export var bullet_speed: float = 16.0

var _jump_was_down := false
var _fire_was_down := false
var _facing := 1.0
var _walk_time := 0.0
var _bullets: Array[Node3D] = []
var _bullet_directions: Array[float] = []
var _visual: Node3D
var _left_leg: Node3D
var _right_leg: Node3D
var _left_arm: Node3D
var _right_arm: Node3D
var _gun_tip := Vector3(0.75, 1.15, 0.0)

func _ready() -> void:
	_build_hero()

func _physics_process(delta: float) -> void:
	var direction := 0.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction += 1.0

	if direction != 0.0:
		_facing = sign(direction)
		_visual.scale.x = _facing

	velocity.x = direction * move_speed
	velocity.z = 0.0

	var jump_down := Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif jump_down and not _jump_was_down:
		velocity.y = jump_velocity
	_jump_was_down = jump_down

	_walk_time += delta * (8.0 if direction != 0.0 else 2.0)
	var swing := sin(_walk_time) * 0.48 if direction != 0.0 and is_on_floor() else 0.0
	_left_leg.rotation.z = swing
	_right_leg.rotation.z = -swing
	_left_arm.rotation.z = -swing * 0.55
	_right_arm.rotation.z = 0.0

	var fire_down := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_CTRL)
	if fire_down and not _fire_was_down:
		_shoot()
	_fire_was_down = fire_down

	_update_bullets(delta)
	move_and_slide()

func _build_hero() -> void:
	_visual = Node3D.new()
	_visual.name = "HeroVisual"
	add_child(_visual)

	var green := _material(Color("#477b42"))
	var dark_green := _material(Color("#294c2e"))
	var light_green := _material(Color("#78a95b"))
	var skin := _material(Color("#d6a477"))
	var visor := _material(Color("#263c49"), 0.15)
	var metal := _material(Color("#424b50"))
	var black := _material(Color("#171d20"))

	_add_box(_visual, "Torso armor", Vector3(0, 0.98, 0), Vector3(0.58, 0.68, 0.34), green)
	_add_box(_visual, "Chest plate", Vector3(0.04, 1.03, -0.19), Vector3(0.34, 0.32, 0.035), light_green)
	_add_box(_visual, "Belt", Vector3(0, 0.61, 0), Vector3(0.56, 0.12, 0.36), dark_green)

	var head := _add_box(_visual, "Head", Vector3(0, 1.52, 0), Vector3(0.38, 0.38, 0.32), skin)
	_add_box(_visual, "Green helmet", Vector3(0, 1.72, 0), Vector3(0.48, 0.22, 0.4), green)
	_add_box(_visual, "Helmet brim", Vector3(0.07, 1.61, -0.02), Vector3(0.54, 0.07, 0.42), dark_green)
	_add_box(_visual, "Visor", Vector3(0.04, 1.53, -0.174), Vector3(0.29, 0.12, 0.025), visor)

	_left_leg = _make_limb("Left leg", Vector3(-0.16, 0.48, 0), Vector3(0.2, 0.48, 0.25), dark_green)
	_right_leg = _make_limb("Right leg", Vector3(0.16, 0.48, 0), Vector3(0.2, 0.48, 0.25), green)
	_visual.add_child(_left_leg)
	_visual.add_child(_right_leg)
	_add_box(_left_leg, "Boot", Vector3(0.04, -0.2, -0.04), Vector3(0.25, 0.16, 0.34), black)
	_add_box(_right_leg, "Boot", Vector3(0.04, -0.2, -0.04), Vector3(0.25, 0.16, 0.34), black)

	_left_arm = _make_limb("Left arm", Vector3(-0.36, 1.12, 0), Vector3(0.19, 0.48, 0.25), green)
	_right_arm = _make_limb("Right arm", Vector3(0.36, 1.13, 0), Vector3(0.19, 0.48, 0.25), green)
	_visual.add_child(_left_arm)
	_visual.add_child(_right_arm)
	_add_box(_left_arm, "Glove", Vector3(0.02, -0.23, -0.02), Vector3(0.2, 0.14, 0.25), black)
	_add_box(_right_arm, "Glove", Vector3(0.02, -0.23, -0.02), Vector3(0.2, 0.14, 0.25), black)

	_add_box(_visual, "Rifle body", Vector3(0.55, 1.12, -0.04), Vector3(0.58, 0.13, 0.13), metal)
	_add_box(_visual, "Rifle barrel", Vector3(0.88, 1.14, -0.04), Vector3(0.3, 0.055, 0.06), black)
	_add_box(_visual, "Rifle stock", Vector3(0.27, 1.08, -0.04), Vector3(0.18, 0.2, 0.12), dark_green)

func _make_limb(label: String, pivot: Vector3, size: Vector3, mat: Material) -> Node3D:
	var node := Node3D.new()
	node.name = label
	node.position = pivot
	_add_box(node, "Armor", Vector3(0, -size.y * 0.5, 0), size, mat)
	return node

func _add_box(parent: Node3D, label: String, pos: Vector3, dimensions: Vector3, mat: Material) -> MeshInstance3D:
	var mesh_node := MeshInstance3D.new()
	mesh_node.name = label
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	mesh_node.mesh = mesh
	mesh_node.material_override = mat
	mesh_node.position = pos
	parent.add_child(mesh_node)
	return mesh_node

func _material(color: Color, metallic: float = 0.0) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.metallic = metallic
	mat.roughness = 0.82
	return mat

func _shoot() -> void:
	var bullet := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = 0.07
	mesh.height = 0.14
	bullet.mesh = mesh
	bullet.material_override = _material(Color("#ffd36a"), 0.2)
	bullet.position = global_position + Vector3(_gun_tip.x * _facing, _gun_tip.y, _gun_tip.z)
	get_parent().add_child(bullet)
	_bullets.append(bullet)
	_bullet_directions.append(_facing)

func _update_bullets(delta: float) -> void:
	for i in range(_bullets.size() - 1, -1, -1):
		var bullet := _bullets[i]
		if not is_instance_valid(bullet):
			_bullets.remove_at(i)
			_bullet_directions.remove_at(i)
			continue
		bullet.position.x += _bullet_directions[i] * bullet_speed * delta
		if absf(bullet.position.x - global_position.x) > 24.0:
			bullet.queue_free()
			_bullets.remove_at(i)
			_bullet_directions.remove_at(i)
