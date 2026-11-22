extends Node3D

@export var health := 50
@export var move_distance := 1.4
@export var move_speed := 1.1
var _start_x := 0.0
var _direction := 1.0
var _time := 0.0
var _body: MeshInstance3D

func _ready() -> void:
	add_to_group("enemies")
	_start_x = position.x
	var armor := _material(Color("#6c4938"))
	var dark := _material(Color("#332b29"))
	var eye := _material(Color("#e8a34b"), 0.2)
	_body = _box(Vector3(0,0.72,0), Vector3(0.72,0.9,0.42), armor)
	_box(Vector3(0,1.28,0), Vector3(0.62,0.34,0.4), dark)
	_box(Vector3(0.17,1.31,-0.22), Vector3(0.12,0.08,0.025), eye)
	_box(Vector3(-0.17,1.31,-0.22), Vector3(0.12,0.08,0.025), eye)
	_box(Vector3(-0.2,0.18,0), Vector3(0.2,0.35,0.28), dark)
	_box(Vector3(0.2,0.18,0), Vector3(0.2,0.35,0.28), dark)

func _process(delta: float) -> void:
	_time += delta
	position.x += _direction * move_speed * delta
	if position.x > _start_x + move_distance:
		_direction = -1.0
	elif position.x < _start_x - move_distance:
		_direction = 1.0
	if _body:
		_body.rotation.z = sin(_time * 5.0) * 0.05

	var player := get_tree().get_first_node_in_group("player")
	if player and global_position.distance_to(player.global_position) < 0.95:
		player.take_damage(12)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
	else:
		_body.scale = Vector3(0.82, 0.82, 0.82)

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
