extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var camera: Camera3D = $Camera3D
var _hud_label: Label

func _ready() -> void:
	_build_test_corridor()
	_build_touch_ui()

func _process(delta: float) -> void:
	camera.position.x = lerpf(camera.position.x, player.position.x + 2.0, minf(delta * 4.0, 1.0))
	if _hud_label:
		_hud_label.text = "ALMOST HERO     TEST ZONE"

func _build_test_corridor() -> void:
	_add_block(Vector3(4.0, 0.55, 0), Vector3(1.3, 1.1, 2.5), Color("#59616a"))
	_add_block(Vector3(8.0, 0.8, 0), Vector3(1.6, 1.6, 2.5), Color("#68705b"))
	_add_block(Vector3(12.0, 0.35, 0), Vector3(2.0, 0.7, 2.5), Color("#59616a"))
	_add_block(Vector3(17.0, 1.1, 0), Vector3(1.4, 2.2, 2.5), Color("#68705b"))
	_add_block(Vector3(22.0, 0.6, 0), Vector3(2.0, 1.2, 2.5), Color("#59616a"))
	_add_block(Vector3(28.0, 1.0, 0), Vector3(1.5, 2.0, 2.5), Color("#68705b"))
	_add_decoration(Vector3(5.5, 2.8, -1.0), Vector3(0.12, 5.0, 0.12), Color("#8a6b42"))
	_add_decoration(Vector3(15.0, 2.8, -1.0), Vector3(0.12, 5.0, 0.12), Color("#8a6b42"))
	_add_decoration(Vector3(25.0, 2.8, -1.0), Vector3(0.12, 5.0, 0.12), Color("#8a6b42"))

func _add_block(pos: Vector3, dimensions: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.position = pos
	add_child(body)
	var mesh_node := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	mesh_node.mesh = mesh
	mesh_node.material_override = _material(color)
	body.add_child(mesh_node)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	body.add_child(collision)

func _add_decoration(pos: Vector3, dimensions: Vector3, color: Color) -> void:
	var node := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	node.mesh = mesh
	node.position = pos
	node.material_override = _material(color)
	add_child(node)

func _material(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.9
	return mat

func _build_touch_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(root)

	_hud_label = Label.new()
	_hud_label.text = "ALMOST HERO     TEST ZONE"
	_hud_label.position = Vector2(22, 18)
	_hud_label.add_theme_font_size_override("font_size", 20)
	_hud_label.add_theme_color_override("font_color", Color("#e7e6d8"))
	root.add_child(_hud_label)

	_make_hold_button(root, "◀", Vector2(24, -100), Vector2(92, -24),
		func(): player.touch_left = true, func(): player.touch_left = false)
	_make_hold_button(root, "▶", Vector2(122, -100), Vector2(190, -24),
		func(): player.touch_right = true, func(): player.touch_right = false)
	_make_hold_button(root, "JUMP", Vector2(-190, -112), Vector2(-104, -26),
		func(): player.touch_jump = true, func(): player.touch_jump = false)
	_make_hold_button(root, "FIRE", Vector2(-96, -112), Vector2(-24, -26),
		func(): player.touch_fire = true, func(): player.touch_fire = false)
	_make_hold_button(root, "ROLL", Vector2(-190, -204), Vector2(-104, -118),
		func(): player.touch_roll = true, func(): player.touch_roll = false)

func _make_hold_button(root: Control, label: String, top_left: Vector2, bottom_right: Vector2, on_press: Callable, on_release: Callable) -> void:
	var button := Button.new()
	button.text = label
	button.anchor_left = 0.0 if top_left.x >= 0 else 1.0
	button.anchor_right = 0.0 if top_left.x >= 0 else 1.0
	button.anchor_top = 1.0
	button.anchor_bottom = 1.0
	button.offset_left = top_left.x
	button.offset_top = top_left.y
	button.offset_right = bottom_right.x
	button.offset_bottom = bottom_right.y
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color("#ffffff"))
	button.modulate = Color(1, 1, 1, 0.88)
	root.add_child(button)
	button.button_down.connect(on_press)
	button.button_up.connect(on_release)
