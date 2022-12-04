extends Node2D


func _save():
	var saver=File.new()
	var save_str="res://txt_stats//s.txt"
	saver.open(save_str,File.WRITE)
	saver.store_string($point.text+" "+$hp.text+" "+$damage.text+" "+$def.text)
	saver.close()

func _load():
	var opener=File.new()
	var open_str="res://txt_stats//s.txt"
	opener.open(open_str,File.READ)
	if opener.file_exists(open_str):
		var stats=opener.get_as_text().split(" ",true)
		$point.text=stats[0]
		$hp.text=stats[1]
		$damage.text=stats[2]
		$def.text=stats[3]
	opener.close()
	
	
func _ready():
	_load()


signal up
func _on_plus_hp_button_down():
	if(int($point.text)>0):
		$hp.text=str(int($hp.text)+48);
		$point.text=str(int($point.text)-1)
		_save()
		emit_signal("up")


func _on_plus_def_button_down():
	if(int($point.text)>0):
		$def.text=str(int($def.text)+4);
		$point.text=str(int($point.text)-1)
		_save()
		emit_signal("up")

func _on_plus_dam_button_down():
	if(int($point.text)>0):
		$damage.text=str(int($damage.text)+10);
		$point.text=str(int($point.text)-1)
		_save()
		emit_signal("up")
