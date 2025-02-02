extends Control

var upgrade_cost_engine = 15
var upgrade_cost_pendant = 15

 
func _ready():
	Bridge.storage.get(["passedLvl", "coins"], Callable(self, "_on_storage_get_completed"))
	Bridge.storage.get(["torque", "turnLeftRight"], Callable(self, "_on_global_player_storage_get_completed"))
	var container = $Levels/Panel/BoxContainer
	for button in container.get_children():
		if button is Button:
			button.connect("pressed", Callable(self, "_on_button_pressed").bind(button))



func _process(delta):
	$Upgrate/CoinsLabel.text = str("Монет: ", int(Global.coins))
	
	var buttons = $Levels/Panel/BoxContainer.get_children()
	for button in buttons:
		var level_to_check = int(button.get_text())
		if level_to_check <= Global.passedLvl:
			button.disabled = false
		else:
			button.disabled = true

	

func _on_storage_get_completed(success, data):
	if success:
		if data[0] != null:
			Global.passedLvl = int(data[0])
			print("passedLvl: ", data[0])
		else:
			Global.passedLvl = 1

			print("passedLvl is null")

		
		if data[1] != null:
			Global.coins = int(data[1])
			print("coins: ", data[1])
		else:
			Global.coins = 0
			print("coins is null")


func _on_global_player_storage_get_completed(success, data):
	if success:
		if data[0] != null:
			GlobalPlayer.TORQUE = float(data[0])
			print("torque: ", data[0])
		else:
			GlobalPlayer.TORQUE = 1500.0

			print("torque is 1500")

		
		if data[1] != null:
			GlobalPlayer.turnLeftRight = float(data[1])
			print("turnLeftRight: ", data[1])
		else:
			GlobalPlayer.turnLeftRight = 5500.0
			print("turnLeftRight is 5500.0")


func _on_button_pressed(button: Button) -> void:
	var SelectLvl = button.text
	var scene_path = "res://scenes/lvls/Level" + SelectLvl + ".tscn"
	if Global.passedLvl >= int(SelectLvl):
		get_tree().change_scene_to_file(scene_path)
	print(scene_path)
	print(Global.passedLvl)
	print(SelectLvl)


func _on_button_start_pressed() -> void:
	$Levels.visible = true
	$Upgrate.visible = false
	$Main.visible = false


func _on_button_upgrate_pressed() -> void:
	$Levels.visible = false
	$Upgrate.visible = true
	$Main.visible = false


func _on_button_back_pressed() -> void:
	$Levels.visible = false
	$Upgrate.visible = false
	$Main.visible = true




func _on_button_upgrate_engine_pressed() -> void:
	if GlobalPlayer.TORQUE == 1500:
		upgrade_cost_engine = 15
	elif GlobalPlayer.TORQUE == 1750:
		upgrade_cost_engine = 25
	elif GlobalPlayer.TORQUE == 2000:
		upgrade_cost_engine = 30
	elif GlobalPlayer.TORQUE == 2250:
		upgrade_cost_engine = 35
	elif GlobalPlayer.TORQUE == 2750:
		upgrade_cost_engine = 40
	elif GlobalPlayer.TORQUE == 3000:
		upgrade_cost_engine = 45
	if Global.coins >= upgrade_cost_engine and GlobalPlayer.TORQUE <= 3000:
		GlobalPlayer.TORQUE += 250
		Global.coins -= upgrade_cost_engine
		$Upgrate/PanelEngine/ASP_upgrate.play()
		$Upgrate/PanelEngine/ProgressBar.value = GlobalPlayer.TORQUE
		$Upgrate/PanelEngine/Label.text = str("Цена улучшения: ", upgrade_cost_engine + 5)
		if $Upgrate/PanelEngine/ProgressBar.value == $Upgrate/PanelEngine/ProgressBar.max_value:
			$Upgrate/PanelEngine/Label.text = str("Максимальный уровень")
	Global._save_data()
	GlobalPlayer._save_data()

func _on_button_upgrate_pendant_pressed() -> void:
	if GlobalPlayer.turnLeftRight == 5500:
		upgrade_cost_pendant = 15
	elif GlobalPlayer.turnLeftRight == 6500:
		upgrade_cost_pendant = 20
	elif GlobalPlayer.turnLeftRight == 7500:
		upgrade_cost_pendant = 25
	elif GlobalPlayer.turnLeftRight == 8500:
		upgrade_cost_pendant = 30
	elif GlobalPlayer.turnLeftRight == 9500:
		upgrade_cost_pendant = 45
	if Global.coins >= upgrade_cost_pendant and GlobalPlayer.turnLeftRight <= 10000:
		GlobalPlayer.turnLeftRight += 1000
		Global.coins -= upgrade_cost_pendant
		$Upgrate/PanelEngine/ASP_upgrate.play()
		$Upgrate/PanelPendant/ProgressBar.value = GlobalPlayer.turnLeftRight
		$Upgrate/PanelPendant/Label.text = str("Цена улучшения: ", upgrade_cost_pendant + 5)
		if $Upgrate/PanelPendant/ProgressBar.value == $Upgrate/PanelPendant/ProgressBar.max_value:
			$Upgrate/PanelPendant/Label.text = str("Максимальный уровень")
	GlobalPlayer._save_data()
	Global._save_data()
