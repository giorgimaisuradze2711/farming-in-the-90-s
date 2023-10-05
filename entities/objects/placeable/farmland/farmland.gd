extends StaticBody3D

@export var crop: Crop
@export var occupied: bool = false

@onready var outline: MeshInstance3D = $CollisionShape3D/MeshInstance3D/Outline

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if is_in_group("hovering"):
		outline.show()
	elif occupied == true and is_in_group("hovering"):
		pass
	else:
		outline.hide()


func player_interact(player: CharacterBody3D, selected_hotbar_item_slot: ItemSlotData, item_on_hand: ItemData) -> void:
	if occupied == false and item_on_hand and item_on_hand.item_type == "Seed":
		var seed_name = item_on_hand.crop
		crop = load("res://entities/objects/crops/%s/%s.tscn" % [seed_name, seed_name]).instantiate()
		add_child(crop)
		occupied = true
		
		selected_hotbar_item_slot.item_quantity -= 1
	elif occupied == true:
		crop.player_interact(player, selected_hotbar_item_slot, item_on_hand)
