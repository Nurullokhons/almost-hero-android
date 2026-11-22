extends CharacterBody3D

@export var move_speed := 5.0
@export var jump_velocity := 7.0
@export var gravity := 18.0
@export var bullet_speed := 16.0

var touch_left := false
var touch_right := false
var touch_jump := false
var touch_fire := false
var touch_roll := false
var _jump_was_down := false
var _fire_timer := 0.0
var _roll_timer := 0.0
var _facing := 1.0
var _walk_time := 0.0
var _bullets: Array[Node3D] = []
var _bullet_dirs: Array[float] = []
var _visual: Node3D
var _left_leg: Node3D
var _right_leg: Node3D
var health := 100
var _damage_cooldown := 0.0

func _ready() -> void:
	add_to_group("player")
	_build_hero()

func _physics_process(delta: float) -> void:
	_fire_timer = maxf(0.0, _fire_timer - delta)
	_damage_cooldown = maxf(0.0, _damage_cooldown - delta)
	_roll_timer = maxf(0.0, _roll_timer - delta)
	var dir := float(touch_right or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) - float(touch_left or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT))
	if dir != 0.0:
		_facing = signf(dir)
		_visual.scale.x = _facing
	if (touch_roll or Input.is_key_pressed(KEY_S)) and is_on_floor() and _roll_timer == 0.0:
		_roll_timer = 0.45
	velocity.x = dir * move_speed * (1.7 if _roll_timer > 0.0 else 1.0)
	velocity.z = 0.0
	var jump_down := touch_jump or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif jump_down and not _jump_was_down:
		velocity.y = jump_velocity
	_jump_was_down = jump_down
	_walk_time += delta * (9.0 if dir != 0.0 else 2.0)
	var swing := sin(_walk_time) * 0.45 if dir != 0.0 and is_on_floor() else 0.0
	_left_leg.rotation.z = swing
	_right_leg.rotation.z = -swing
	_visual.rotation.z = -_facing * 1.8 * (_roll_timer / 0.45) if _roll_timer > 0.0 else 0.0
	if (touch_fire or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_CTRL)) and _fire_timer <= 0.0:
		_shoot()
		_fire_timer = 0.2
	_update_bullets(delta)
	move_and_slide()

func _build_hero() -> void:
	_visual = Node3D.new()
	add_child(_visual)
	var green := _mat(Color("#477b42"))
	var dark := _mat(Color("#294c2e"))
	var light := _mat(Color("#78a95b"))
	var black := _mat(Color("#171d20"))
	var metal := _mat(Color("#424b50"))
	_box(_visual, Vector3(0,0.98,0), Vector3(0.58,0.68,0.34), green)
	_box(_visual, Vector3(0.04,1.03,-0.19), Vector3(0.34,0.32,0.035), light)
	_box(_visual, Vector3(0,0.61,0), Vector3(0.56,0.12,0.36), dark)
	_box(_visual, Vector3(0,1.52,0), Vector3(0.38,0.38,0.32), _mat(Color("#d6a477")))
	_box(_visual, Vector3(0,1.72,0), Vector3(0.48,0.22,0.4), green)
	_box(_visual, Vector3(0.07,1.61,-0.02), Vector3(0.54,0.07,0.42), dark)
	_box(_visual, Vector3(0.04,1.53,-0.174), Vector3(0.29,0.12,0.025), _mat(Color("#263c49")))
	_left_leg = _limb(Vector3(-0.16,0.48,0), Vector3(0.2,0.48,0.25), dark)
	_right_leg = _limb(Vector3(0.16,0.48,0), Vector3(0.2,0.48,0.25), green)
	_visual.add_child(_left_leg)
	_visual.add_child(_right_leg)
	_box(_left_leg, Vector3(0.04,-0.2,-0.04), Vector3(0.25,0.16,0.34), black)
	_box(_right_leg, Vector3(0.04,-0.2,-0.04), Vector3(0.25,0.16,0.34), black)
	_box(_visual, Vector3(-0.36,1.0,0), Vector3(0.19,0.48,0.25), green)
	_box(_visual, Vector3(0.36,1.0,0), Vector3(0.19,0.48,0.25), green)
	_box(_visual, Vector3(0.55,1.12,-0.04), Vector3(0.58,0.13,0.13), metal)
	_box(_visual, Vector3(0.88,1.14,-0.04), Vector3(0.3,0.055,0.06), black)

func _limb(pos: Vector3, size: Vector3, mat: Material) -> Node3D:
	var n := Node3D.new()
	n.position = pos
	_box(n, Vector3(0,-size.y*0.5,0), size, mat)
	return n

func _box(parent: Node3D, pos: Vector3, size: Vector3, mat: Material) -> void:
	var m := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	m.mesh = mesh
	m.material_override = mat
	m.position = pos
	parent.add_child(m)

func _mat(color: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 0.85
	return m

func _shoot() -> void:
	var b := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = 0.07
	mesh.height = 0.14
	b.mesh = mesh
	b.material_override = _mat(Color("#ffd36a"))
	b.global_position = global_position + Vector3(0.85 * _facing, 1.15, -0.1)
	get_parent().add_child(b)
	var flash := MeshInstance3D.new()
	var flash_mesh := SphereMesh.new()
	flash_mesh.radius = 0.13
	flash_mesh.height = 0.26
	flash.mesh = flash_mesh
	flash.material_override = _mat(Color("#ffb84d"))
	flash.global_position = b.global_position + Vector3(0.18 * _facing, 0.0, -0.02)
	get_parent().add_child(flash)
	get_tree().create_timer(0.07).timeout.connect(flash.queue_free)
	_bullets.append(b)
	_bullet_dirs.append(_facing)

func _update_bullets(delta: float) -> void:
	for i in range(_bullets.size()-1, -1, -1):
		var b := _bullets[i]
		if not is_instance_valid(b):
			_bullets.remove_at(i)
			_bullet_dirs.remove_at(i)
		else:
			b.global_position.x += _bullet_dirs[i] * bullet_speed * delta
			var hit_enemy := false
			for enemy in get_tree().get_nodes_in_group("enemies"):
				if is_instance_valid(enemy) and (enemy.global_position + Vector3(0, 1.0, 0)).distance_to(b.global_position) < 0.8:
					enemy.take_damage(25)
					hit_enemy = true
					break
			if hit_enemy or absf(b.global_position.x-global_position.x) > 22.0:
				b.queue_free()
				_bullets.remove_at(i)
				_bullet_dirs.remove_at(i)

func take_damage(amount: int) -> void:
	if _damage_cooldown > 0.0:
		return
	health = maxi(0, health - amount)
	_damage_cooldown = 0.8
	if health == 0:
		global_position = Vector3(-3, 0.76, 0)
		health = 100
