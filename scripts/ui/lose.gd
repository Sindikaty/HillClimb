extends Control


func _on_button_restart_pressed() -> void:
	GlobalPlayer.player_died = false
	get_tree().reload_current_scene()


func _on_button_go_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
