extends Node2D


func _ready():
	pass # Replace with function body.



var flag=true
#показывает и скрывает меню статов
func _on_STATS_button_down():
	if flag:
		$stats.visible=true
		flag=false
	else:
		$stats.visible=false
		flag=true

#вызывается при повышении уровня в бою, для отображение новой инфы на экране
func _on_Game_lvl_up(a,e):
	$stats/point.text=str(int($stats/point.text)+3)
	$lvl.text=str(int($lvl.text)+1)
	$ProgressBar.max_value=e
	$ProgressBar.value=a

signal s
func _on_stats_up():
	emit_signal("s")


func _on_Game_show(l, m):
	$Victory.visible=true 
	$Victory/gold.text=str(m)
	$Victory/lvl.text=str(l)
