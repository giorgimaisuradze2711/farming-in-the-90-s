extends StaticBody3D
class_name Crop

@export var item_slot_data: ItemSlotData

@export var current_days: int : set = _set_current_days
@export var sprout_days: int
@export var bud_days: int
@export var ripe_days: int
#@export_enum ("Seed", "Sprout", "Bud", "Ripe", "Dead") var growth_stage: String
@export var is_ripe: bool = false
@export var multiple_harvest: bool = false
@export var multiple_harvest_count: int

@onready var seed: CollisionShape3D = $Seed
@onready var sprout: CollisionShape3D = $Sprout
@onready var bud: CollisionShape3D = $Bud
@onready var ripe: CollisionShape3D = $Ripe

var outline: MeshInstance3D


func _ready() -> void:
	add_to_group("crop")
	_set_growth_stage()


func _set_current_days(value) -> void:
	current_days = value
	_set_growth_stage()


func _set_growth_stage() -> void:
	if current_days in range(0, sprout_days):
		seed.show()
	elif current_days in range(sprout_days, bud_days):
		seed.hide()
		sprout.show()
	elif current_days in range(bud_days, ripe_days):
		sprout.hide()
		bud.show()
	elif current_days in range(ripe_days, 30):
		bud.hide()
		ripe.show()
		is_ripe = true

func player_interact(player: CharacterBody3D, selected_hotbar_item_slot: ItemSlotData, item_on_hand: ItemData) -> void:
	if is_ripe == true:
		if player.hotbar_data.pick_up_item_slot_data(item_slot_data):
			_remove()
		elif player.inventory_data.pick_up_item_slot_data(item_slot_data):
			_remove()
	elif not item_on_hand == null and item_on_hand.name == "Shovel":
		_remove()

func _remove() -> void:
		get_parent().occupied = false
		remove_from_group("hovering")
		queue_free()
