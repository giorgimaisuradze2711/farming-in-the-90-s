extends Control

const ITEM_SLOT = preload("res://gui/inventory_interface/item_slot/item_slot.tscn")
@onready var grid_container: GridContainer = $MarginContainer/GridContainer

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.connect("inventory_updated", Callable(self, "populate_item_grid"))
	populate_item_grid(inventory_data)


func populate_item_grid(inventory_data: InventoryData) -> void:
	for item_slot in grid_container.get_children():
		item_slot.queue_free()

	for item_slot_data in inventory_data.item_slot_data_array:
		var item_slot = ITEM_SLOT.instantiate()
		grid_container.add_child(item_slot)
		item_slot.connect("item_slot_clicked", Callable(inventory_data, "on_item_slot_clicked"))

		if item_slot_data:
			item_slot.set_item_slot_data(item_slot_data)

func on_hotbar_slot_selected(selected_hotbar_slot_index: int) -> void:
	var selector: TextureRect = $MarginContainer/Selector
	var selected_slot = grid_container.get_child(selected_hotbar_slot_index)
	selector.position.x = selected_slot.position.x + 8
