@tool
extends Resource
class_name ItemData

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var mesh: Mesh
@export var stackable: bool = true
@export var consumable: bool = true
var item_type: String
var crop: String
var placeable_object:String
var can_be_bought: bool = false
var buy_price: int = 0
var can_be_sold: bool = false
var sell_price: int = 0

func _set(property: StringName, value: Variant) -> bool:
	match property:
		"Item Type":
			item_type = value
			notify_property_list_changed()

		"Crop":
			crop = value

		"Placeable Object":
			placeable_object = value

		"Can Be Sold":
			can_be_sold = value
			notify_property_list_changed()

		"Sell Price":
			sell_price = value

		"Can Be Bought":
			can_be_bought = value
			notify_property_list_changed()

		"Buy Price":
			buy_price = value

		_:
			return false

	return true

func _get(property: StringName) -> Variant:
	match property:
		"Item Type":
			return item_type

		"Crop":
			return crop

		"Placeable Object":
			return placeable_object

		"Can Be Sold":
			return can_be_sold

		"Sell Price":
			return sell_price

		"Can Be Bought":
			return can_be_bought

		"Buy Price":
			return buy_price

	return null

func _get_property_list() -> Array:
	var property_list: Array = []

	property_list.append({
		"name": "Item Type",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Tool,Placeable,Seed,Vegetable,Fruit,Ore"
	})

	if item_type == "Seed":
		property_list.append({
			"name": "Crop",
			"type": TYPE_STRING
		})
	
	if item_type == "Placeable":
		property_list.append({
			"name": "Placeable Object",
			"type": TYPE_STRING
		})

	property_list.append(
		{
			"name": "Can Be Sold",
			"type": TYPE_BOOL
		}
	)

	if can_be_sold == true:
		property_list.append({
			"name": "Sell Price",
			"type": TYPE_INT
		})

	property_list.append(
		{
			"name": "Can Be Bought",
			"type": TYPE_BOOL
		}
	)

	if can_be_bought == true:
		property_list.append({
			"name": "Buy Price",
			"type": TYPE_INT
		})

	return property_list
