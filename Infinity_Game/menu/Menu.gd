extends Node2D




func _ready():
	pass

func _on_Button_button_down():
	get_tree().change_scene("res://game/Game.tscn")


func _on_b_inventory_button_down():
	get_tree().change_scene("res://inventory/Inventory.tscn")


func _on_b_settings_button_down():
	get_tree().change_scene("res://settings/Settings.tscn")
