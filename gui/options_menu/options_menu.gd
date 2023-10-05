extends Control

signal toggle_options_menu

@onready var video_settings: Button = $"ButtonContainer/Video Settings"
@onready var audio_settings: Button = $"ButtonContainer/Audio Settings"
@onready var control_settings: Button = $"ButtonContainer/Control Settings"
@onready var resolution_button: OptionButton = $"VideoSettings/Settings Container/ResolutionSetting/ResolutionButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_video_settings_pressed() -> void:
	audio_settings.button_pressed = false
	control_settings.button_pressed = false


func _on_audio_settings_pressed() -> void:
	video_settings.button_pressed = false
	control_settings.button_pressed = false


func _on_control_settings_pressed() -> void:
	video_settings.button_pressed = false
	audio_settings.button_pressed = false


func _on_back_pressed() -> void:
	visible = false
	toggle_options_menu.emit()


func _on_resolution_button_item_selected(index: int) -> void:
	var resolution: PackedStringArray = resolution_button.get_item_text(index).split("x")
	var width: int = resolution[0].to_int()
	var height: int = resolution[1].to_int()
	DisplayServer.window_set_size(Vector2(width, height))
#	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#	get_window().size = Vector2(width, height)
#	ProjectSettings.set_setting("display/window/size/viewport_width", width)
#	ProjectSettings.set_setting("display/window/size/viewport_height", height)
#	ProjectSettings.save()
