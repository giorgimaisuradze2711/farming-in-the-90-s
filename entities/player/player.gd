extends CharacterBody3D

signal hotbar_slot_selected(selected_hotbar_slot_index: int)
signal toggle_inventory

@export var hotbar_data: InventoryData
@export var inventory_data: InventoryData

var selected_hotbar_item_slot_index: int
var selected_hotbar_item_slot: ItemSlotData
var item_on_hand: ItemData
var placeable_object_on_hand: Placeable

@onready var neck: Node3D = $Neck
@onready var camera_3d: Camera3D = $Neck/Camera3D
@onready var interaction_ray: RayCast3D = $Neck/Camera3D/InteractionRay
@onready var ground_detector: RayCast3D = $Neck/Camera3D/GroundDetector
@onready var mouse_cursor_texture: TextureRect = $MouseCursorTexture
@onready var item_placeholder: MeshInstance3D = $Neck/Camera3D/RightHand/ItemPlaceholder

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_sensitivity: float = 0.01

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_set_selected_hotbar_item_slot_index(selected_hotbar_item_slot_index)


func _physics_process(delta: float) -> void:
	if interaction_ray.is_colliding() and not interaction_ray.get_collider() == null:
		if get_tree().has_group("hovering"):
			get_tree().get_first_node_in_group("hovering").remove_from_group("hovering")

		interaction_ray.get_collider().add_to_group("hovering")
	else:
		if get_tree().has_group("hovering"):
			get_tree().get_first_node_in_group("hovering").remove_from_group("hovering")
	
	if ground_detector.is_colliding() and get_tree().has_group("Fantom"):
		placeable_object_on_hand.global_position = ground_detector.get_collision_point()

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	if Input.is_action_pressed("interact") and interaction_ray.is_colliding():
		_interact()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	if event.is_action_pressed("inventory"):
		mouse_cursor_texture.visible = not mouse_cursor_texture.visible
		toggle_inventory.emit()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
		_set_selected_hotbar_item_slot_index(1)

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
		_set_selected_hotbar_item_slot_index(-1)


func _set_selected_hotbar_item_slot_index(value: int) -> void:
	selected_hotbar_item_slot_index += value

	if selected_hotbar_item_slot_index < 0:
		selected_hotbar_item_slot_index = 7
	elif selected_hotbar_item_slot_index > 7:
		selected_hotbar_item_slot_index = 0

	hotbar_slot_selected.emit(selected_hotbar_item_slot_index)

	_set_selected_hotbar_slot(selected_hotbar_item_slot_index)


func _set_selected_hotbar_slot(index: int) -> void:
	selected_hotbar_item_slot = hotbar_data.item_slot_data_array[index]
	
	if get_tree().has_group("Fantom"):
		placeable_object_on_hand.queue_free()

	if selected_hotbar_item_slot:
		item_on_hand = selected_hotbar_item_slot.item_data
		item_placeholder.mesh = item_on_hand.mesh
		
		if item_on_hand.item_type == "Placeable":
			_spawn_placeable_object()
	else:
		item_on_hand = null
		item_placeholder.mesh = null


func _interact() -> void:
	var interaction_body: Object = interaction_ray.get_collider()
	interaction_body.player_interact(self, selected_hotbar_item_slot, item_on_hand)

func _spawn_placeable_object() -> void:
	placeable_object_on_hand = load(item_on_hand.placeable_object).instantiate()
	placeable_object_on_hand.fantom = true
	placeable_object_on_hand.add_to_group("Fantom")
	get_parent().add_child(placeable_object_on_hand)
