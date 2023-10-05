extends PanelContainer

signal item_slot_clicked(index:int, button:int)

@onready var item_icon: TextureRect = $MarginContainer/ItemIcon
@onready var item_quantity_label: Label = $MarginContainer/ItemQuantityLabel

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT \
	or event.button_index == MOUSE_BUTTON_RIGHT) and event.is_pressed():
		item_slot_clicked.emit(get_index(), event.button_index)


func set_item_slot_data(item_slot_data: ItemSlotData) -> void:
	var item_data = item_slot_data.item_data
	item_icon.texture = item_data.icon
	
	if item_slot_data.item_quantity > 1:
		item_quantity_label.text = "x%s " % item_slot_data.item_quantity
		item_quantity_label.show()
	else:
		item_quantity_label.hide()
