extends Node3D
class_name World

@onready var inventory_interface: Control = $InventoryInterfaceLayer/InventoryInterface
@onready var player: CharacterBody3D = $Player

#@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var sun: DirectionalLight3D = $Sun
#@onready var sky_material = world_environment.get_environment().get_sky().get_material()

@export_enum ("Spring", "Summer", "Autumn", "Winter") var season: String
@export var day_length: float
@onready var day_night_cycle_timer: Timer = $DayNightCycleTimer
var day_time_ratio: float
var night_time_ratio: float
var passed_time: int = 0

var sky_curve: float

var sky_top_color: Color
var sky_top_color_r: float
var sky_top_color_g: float
var sky_top_color_b: float

var sky_horizon_color: Color
var sky_horizon_color_r: float
var sky_horizon_color_g: float
var sky_horizon_color_b: float

func _ready() -> void:
	day_night_cycle_timer.set_wait_time(day_length)
	
	player.connect("hotbar_slot_selected", Callable(inventory_interface, "on_hotbar_slot_selected"))
	player.connect("toggle_inventory", Callable(inventory_interface, "on_toggle_inventory"))

	inventory_interface.set_player_hotbar_data(player.hotbar_data)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	_set_season()


func _physics_process(delta: float) -> void:
#	pass
	sun.rotate_x(-deg_to_rad(180/day_length) * delta)
#	sky_material.set_sky_top_color(Color(abs(cos(sun.rotation.x)) - .8, abs(sin(sun.rotation.x)), abs(sin(sun.rotation.x)) + .6))
#	sky_material.set_sky_horizon_color(Color(abs(cos(sun.rotation.x)), abs(sin(sun.rotation.x)) + .6, abs(sin(sun.rotation.x)) + .4))
#	sky_material.set_ground_horizon_color(Color(abs(cos(sun.rotation.x)), abs(sin(sun.rotation.x)) + .6, abs(sin(sun.rotation.x)) + .4))
#	sky_material.set_ground_bottom_color(Color(abs(cos(sun.rotation.x)), abs(sin(sun.rotation.x)) + .6, abs(sin(sun.rotation.x)) + .4))

func _set_season() -> void:
	match season:
		"Spring":
			day_time_ratio = .5
			night_time_ratio = .5
		"Summer":
			day_time_ratio = .75
			night_time_ratio = .25
		"Autumn":
			day_time_ratio = .5
			night_time_ratio = .5
		"Winter":
			day_time_ratio = .25
			night_time_ratio = .75

func _on_day_night_cycle_timer_timeout() -> void:
	for crop in get_tree().get_nodes_in_group("crop"):
		crop.current_days += 1
