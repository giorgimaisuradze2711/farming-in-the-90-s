extends StaticBody3D
class_name Placeable

var is_colliding: bool
var can_be_placed: bool

@onready var object_mesh: MeshInstance3D = $CollisionShape3D/MeshInstance3D
@onready var object_mesh_materia: StandardMaterial3D

var color_original: Color
var color_red: Color = Color(.8, 0, 0, .5)
var color_green: Color = Color(0, .8, .2, .5)
var color_white: Color = Color(.6, .6, .6, .9)

func _ready() -> void:
	object_mesh_materia = object_mesh.get_active_material(0)
	color_original = object_mesh_materia.albedo_color
	
	_check_fantom()
	
	if is_in_group("Fantom"):
		check_placeable()

func _process(delta: float) -> void:
	if is_in_group("hovering") and not get_tree().has_group("Fantom"):
		object_mesh_materia.albedo_color = color_white
	elif not is_in_group("hovering") and not get_tree().has_group("Fantom"):
		object_mesh_materia.albedo_color = color_original

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_in_group("Fantom"):
		check_placeable()
	
	if event is InputEventMouseButton and can_be_placed and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		place()

func check_placeable() -> void:
	if is_colliding and is_in_group("Fantom"):
		can_be_placed = false
		object_mesh_materia.albedo_color = color_red
	else:
		can_be_placed = true
		object_mesh_materia.albedo_color = color_green

func _on_object_detector_body_entered(body: Node3D) -> void:
	is_colliding = true

func _on_object_detector_body_exited(body: Node3D) -> void:
	is_colliding = false

func place() -> void:
	remove_from_group("Fantom")
	set_collision_layer_value(4, false)
	set_collision_layer_value(3, true)
	object_mesh_materia.albedo_color = color_original

func _check_fantom() -> void:
	if not is_in_group("Fantom"):
		set_collision_layer_value(4, false)
		set_collision_layer_value(3, true)
