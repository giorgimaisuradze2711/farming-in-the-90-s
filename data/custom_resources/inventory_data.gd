extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index:int, button:int)

@export var item_slot_data_array: Array[ItemSlotData]

func pick_up_item_slot_data(item_slot_data:ItemSlotData) -> bool:
	for i in item_slot_data_array.size():
		if item_slot_data_array[i] and item_slot_data_array[i].can_merge_with(item_slot_data):
			item_slot_data_array[i].fully_merge_with(item_slot_data.create_single_item_slot_data())
			inventory_updated.emit(self)
			return true
	
	for i in item_slot_data_array.size():
		if not item_slot_data_array[i]:
			item_slot_data_array[i] = item_slot_data.create_single_item_slot_data()
			inventory_updated.emit(self)
			return true
	
	return false

func grab_item_slot_data(index:int) -> ItemSlotData:
	var item_slot_data = item_slot_data_array[index]
	
	if item_slot_data:
		item_slot_data_array[index] = null
		inventory_updated.emit(self)
		return item_slot_data
	else:
		return null


func grab_split_item_slot_data(index:int) -> ItemSlotData:
	var item_slot_data = item_slot_data_array[index]
	
	if item_slot_data.can_split():
		item_slot_data = item_slot_data_array[index].split_item_quantity()
		inventory_updated.emit(self)
		return item_slot_data
	else:
		return grab_item_slot_data(index)


func drop_item_slot_data(grabbed_item_slot_data:ItemSlotData, index:int) -> ItemSlotData:
	var item_slot_data = item_slot_data_array[index]
	
	var return_item_slot_data: ItemSlotData
	if item_slot_data and item_slot_data.can_fully_merge_with(grabbed_item_slot_data):
		item_slot_data.fully_merge_with(grabbed_item_slot_data)
	else:
		item_slot_data_array[index] = grabbed_item_slot_data
		return_item_slot_data = item_slot_data
	
	inventory_updated.emit(self)
	return return_item_slot_data

func drop_single_item_slot_data(grabbed_item_slot_data:ItemSlotData, index:int) -> ItemSlotData:
	var item_slot_data = item_slot_data_array[index]
	
	if not item_slot_data:
		item_slot_data_array[index] = grabbed_item_slot_data.create_single_item_slot_data()
	elif item_slot_data.can_merge_with(grabbed_item_slot_data):
		item_slot_data.fully_merge_with(grabbed_item_slot_data.create_single_item_slot_data())
		
	inventory_updated.emit(self)
	
	if grabbed_item_slot_data.quantity > 0:
		return grabbed_item_slot_data
	else:
		return null

func on_item_slot_clicked(index:int, button:int) -> void:
	inventory_interact.emit(self, index, button)
