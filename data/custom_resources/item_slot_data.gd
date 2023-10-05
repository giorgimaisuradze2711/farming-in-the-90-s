extends Resource
class_name ItemSlotData


const MAX_STACK_SIZE = 32
@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var item_quantity: int : set = set_item_quantity


func can_merge_with(other_slot_data:ItemSlotData) -> bool:
	return item_data == other_slot_data.item_data \
	and item_data.stackable \
	and item_quantity < MAX_STACK_SIZE


func can_fully_merge_with(other_slot_data:ItemSlotData) -> bool:
	return item_data == other_slot_data.item_data \
	and item_data.stackable \
	and item_quantity + other_slot_data.item_quantity < MAX_STACK_SIZE


func can_split() -> bool:
	return item_data.stackable and item_quantity > 1


func fully_merge_with(other_slot_data:ItemSlotData) -> void:
	item_quantity += other_slot_data.item_quantity


func split_item_quantity() -> ItemSlotData:
	var new_item_slot_data: ItemSlotData = duplicate()
	new_item_slot_data.item_quantity = ceili(float(item_quantity) / 2)
	item_quantity = floori(float(item_quantity) / 2)
	
	return new_item_slot_data


func create_single_item_slot_data() -> ItemSlotData:
	var new_item_slot_data: ItemSlotData = duplicate()
	new_item_slot_data.item_quantity = 1
	item_quantity -= 1
	
	return new_item_slot_data


func set_item_quantity(value:int) -> void:
	item_quantity = value
	
	if item_quantity > 1 and not item_data.stackable:
		item_quantity = 1
		push_error("%s Is Not Stackable!" % item_data.name)
