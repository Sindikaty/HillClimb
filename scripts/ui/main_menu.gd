extends Control

var upgrade_cost_engine = 15
var upgrade_cost_pendant = 15

 
func _ready():
	var container = $Levels/Panel/BoxContainer
	for button in container.get_children():
		if button is Button:
			button.connect("pressed", Callable(self, "_on_button_pressed").bind(button))

	var buttons = $Levels/Panel/BoxContainer.get_children()
	for button in buttons:
		var level_to_check = int(button.get_text())
		if level_to_check <= Global.passedLvl:
			button.disabled = false
		else:
			button.disabled = true


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


func _process(delta: float) -> void:
	$Upgrate/CoinsLabel.text = str("Монет: ", int(Global.coins))


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
