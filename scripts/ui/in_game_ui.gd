extends CanvasLayer

@onready var panel: ColorRect = $settings/Panel

@onready var soundIconOn = preload("res://assets/sprite/UI_texture/UI_main_menu/textureButton/wolume_on.png")
@onready var soundIconOff = preload("res://assets/sprite/UI_texture/UI_main_menu/textureButton/wolume_off.png")

var sound_enabled: bool = true
var game_paused: bool = false

func _ready() -> void:
	update_icon()


func _on_button_pressed() -> void:
	GlobalPlayer.player_died = false
	get_tree().reload_current_scene()

func _on_settings_button_pressed() -> void:
	game_paused = !game_paused
	panel.visible = game_paused
	get_tree().paused = game_paused

func _on_restart_button_pressed() -> void:
	game_paused = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	game_paused = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_sound_button_pressed() -> void:
	Global.sound_enabled = !Global.sound_enabled
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), not Global.sound_enabled)
	update_icon()

func update_icon():
	if Global.sound_enabled:
		$settings/Panel/soundButton.icon = soundIconOn
	else:
		$settings/Panel/soundButton.icon = soundIconOff
