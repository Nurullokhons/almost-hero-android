extends Node3D

@export var health := 50
@export var move_distance := 1.4
@export var move_speed := 1.1
var _start_x := 0.0
var _direction := 1.0
var _time := 0.0
var _body: MeshInstance3D
var _body_material: StandardMaterial3D
var _health_fill: MeshInstance3D
var _health_fill_mesh: BoxMesh
var _hit_flash := 0.0

func _ready() -> void:
	add_to_group("enemies")
	_start_x = position.x
	_body_material = _material(Color("#8a4935"))
	var dark := _material(Color("#342b2a"))
	var trim := _material(Color("#c16b42"), 0.1)
	var eye := _material(Color("#ffb347"), 0.15)
	_body = _box(Vector3(0,0.72,0), Vector3(0.72,0.9,0.42), _body_material)
	_box(Vector3(0,1.28,0), Vector3(0.62,0.34,0.4), dark)
	_box(Vector3(0.17,1.31,-0.22), Vector3(0.12,0.08,0.025), eye)
	_box(Vector3(-0.17,1.31,-0.22), Vector3(0.12,0.08,0.025), eye)
	_box(Vector3(0,0.98,-0.235), Vector3(0.4,0.1,0.035), trim)
	_box(Vector3(-0.2,0.18,0), Vector3(0.2,0.35,0.28), dark)
	_box(Vector3(0.2,0.18,0), Vector3(0.2,0.35,0.28), dark)
	_box(Vector3(-0.48,0.86,0), Vector3(0.2,0.48,0.28), dark)
	_box(Vector3(0.48,0.86,0), Vector3(0.2,0.48,0.28), dark)
	_box(Vector3(0,1.52,0), Vector3(0.12,0.22,0.12), trim)
	_add_health_bar()

func _process(delta: float) -> void:
	_time += delta
	position.x += _direction * move_speed * delta
	if position.x > _start_x + move_distance:
		_direction = -1.0
	elif position.x < _start_x - move_distance:
		_direction = 1.0
	if _body:
		_body.rotation.z = sin(_time * 5.0) * 0.055
	_hit_flash = maxf(0.0, _hit_flash - delta)
	_body_material.albedo_color = Color("#fff0d0") if _hit_flash > 0.0 else Color("#8a4935")
	var player := get_tree().get_first_node_in_group("player")
	if player and global_position.distance_to(player.global_position) < 0.95:
		player.take_damage(12)

func take_damage(amount: int) -> void:
	health = maxi(0, health - amount)
	_hit_flash = 0.12
	_update_health_bar()
	if health <= 0:
		queue_free()

func _add_health_bar() -> void:
	var back := _box(Vector3(0,1.78,-0.05), Vector3(0.82,0.09,0.06), _material(Color("#241e1d")))
	_health_fill_mesh = BoxMesh.new()
	_health_fill_mesh.size = Vector3(0.76,0.055,0.035)
	_health_fill = MeshInstance3D.new()
	_health_fill.mesh = _health_fill_mesh
	_health_fill.material_override = _material(Color("#d75b43"))
	_health_fill.position = Vector3(0,1.78,-0.09)
	add_child(_health_fill)

func _update_health_bar() -> void:
	if _health_fill_mesh:
		_health_fill_mesh.size.x = 0.76 * float(health) / 50.0
		_health_fill.position.x = -0.38 + _health_fill_mesh.size.x * 0.5

func _box(pos: Vector3, dimensions: Vector3, mat: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	node.mesh = mesh
	node.material_override = mat
	node.position = pos
	add_child(node)
	return node

func _material(color: Color, metallic := 0.0) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.metallic = metallic
	mat.roughness = 0.88
	return mat
