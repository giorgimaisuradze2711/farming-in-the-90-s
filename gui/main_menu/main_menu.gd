extends Control

@onready var title: Label = $Title
@onready var button_container: VBoxContainer = $ButtonContainer
@onready var options: Button = $ButtonContainer/Options
@onready var options_menu: Control = $OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_menu.connect("toggle_options_menu", Callable(self,"_on_toggle_options_menu"))
#	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://world/farm.tscn")


func _on_toggle_options_menu():
	options.button_pressed = not options.button_pressed
	options.pressed.emit()


func _on_options_pressed() -> void:
	options_menu.visible = options.button_pressed
	title.visible = not options.button_pressed
	button_container.visible = not options.button_pressed


func _on_quit_pressed() -> void:
	get_tree().quit()
