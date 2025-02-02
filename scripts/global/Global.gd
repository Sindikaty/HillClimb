extends Node

var passedLvl = 1
var Stones = 0
var coins = 400
var sound_enabled: bool = true
func _ready():
	print(Global.passedLvl)

func _save_data():
	Bridge.storage.set(["passedLvl", "coins"], [Global.passedLvl, Global.coins])

