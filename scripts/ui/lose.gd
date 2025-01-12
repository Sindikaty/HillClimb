extends Control


func _on_button_restart_pressed() -> void:
	get_tree().reload_current_scene()
	GlobalPlayer.player_died = false


func _on_button_go_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
