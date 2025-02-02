extends Node

var TORQUE := 1500.0
var turnLeftRight := 5500.0
var player_died = false



func _save_data():
	Bridge.storage.set(["torque", "turnLeftRight"], [GlobalPlayer.TORQUE, GlobalPlayer.turnLeftRight])
