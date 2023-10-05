extends Control

signal hotbar_slot_selected(selected_hotbar_slot_index: int)

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var player_inventory_panel: Panel = $PlayerInventoryPanel
@onready var hotbar: PanelContainer = $Hotbar
@onready var grabbed_item_slot: PanelContainer = $GrabbedItemSlot
var grabbed_item_slot_data: ItemSlotData

func _ready() -> void:
	connect("hotbar_slot_selected", Callable(hotbar, "on_hotbar_slot_selected"))


func _physics_process(delta: float) -> void:
	if grabbed_item_slot.visible:
		grabbed_item_slot.global_position = get_global_mouse_position() + Vector2(1, 1)


func set_player_hotbar_data(player_hotbar_data: InventoryData) -> void:
	player_hotbar_data.connect("inventory_interact", Callable(self, "on_inventory_interact"))
	hotbar.set_inventory_data(player_hotbar_data)


func set_player_inventory_data(player_inventory_data: InventoryData) -> void:
	player_inventory_data.connect("inventory_interact", Callable(self, "on_inventory_interact"))
	player_inventory.set_inventory_data(player_inventory_data)


func on_toggle_inventory() -> void:
	player_inventory.visible = not player_inventory.visible
	player_inventory_panel.visible = not player_inventory_panel.visible

	if player_inventory.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#	if external_inventory_owner and inventory_interface.visible:
#		inventory_interface.set_external_inventory(external_inventory_owner)
#	else:
#		inventory_interface.clear_external_inventory()

func on_inventory_interact(inventory_data: InventoryData, index:int, button:int) -> void:
	match [grabbed_item_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_item_slot_data = inventory_data.grab_item_slot_data(index)
		[null, MOUSE_BUTTON_RIGHT]:
			grabbed_item_slot_data = inventory_data.grab_split_item_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_item_slot_data = inventory_data.drop_item_slot_data(grabbed_item_slot_data,index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_item_slot_data = inventory_data.drop_single_item_slot_data(grabbed_item_slot_data,index)
	
	update_grabbed_item_slot()

func update_grabbed_item_slot() -> void:
	if grabbed_item_slot_data:
		grabbed_item_slot.show()
		grabbed_item_slot.set_item_slot_data(grabbed_item_slot_data)
	else:
		grabbed_item_slot.hide()

func on_hotbar_slot_selected(selected_hotbar_slot_index: int) -> void:
	hotbar_slot_selected.emit(selected_hotbar_slot_index)
