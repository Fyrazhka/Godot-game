extends Node2D

func _save(stroka):
	var saver=File.new()
	var save_str="res://txt_inventory//"+stroka+".txt"
	saver.open(save_str,File.WRITE)
	if stroka=="gold":
		saver.store_string($gold.text)
	if stroka=="UP":
		saver.store_string($costUP1.text+" "+$costUP2.text+" "+$costUP3.text+" "+$costUP4.text)
	if stroka=="stats":
		saver.store_string($luckyInt.text+" "+$DamageInt.text+" "+$HealthInt.text+" "+$DefInt.text)
	saver.close()

func all_load(stroka):
	var opener=File.new()
	var open_str="res://txt_inventory//"+stroka+".txt"
	opener.open(open_str,File.READ)
	if opener.file_exists(open_str):
		if stroka=="gold":
			$gold.text=opener.get_as_text()
		if stroka=="UP":
			var up=opener.get_as_text().split(" ",true)
			$costUP1.text=up[0]
			$costUP2.text=up[1]
			$costUP3.text=up[2]
			$costUP4.text=up[3]
		if stroka=="stats":
			var stats=opener.get_as_text().split(" ",true)
			$luckyInt.text=stats[0]
			$DamageInt.text=stats[1]
			$HealthInt.text=stats[2]
			$DefInt.text=stats[3]
	opener.close()


func _ready():
	all_load("gold")
	all_load("UP")
	all_load("stats")
#кнопка возврата в меню
func _on_Button_button_down():
	_save("gold")
	_save("UP")
	_save("stats")
	get_tree().change_scene("res://menu/Menu.tscn")

func up_stats(index):
	var opener=File.new()
	var open_str="res://txt_inventory//"+"flag"+".txt"
	opener.open(open_str,File.READ)
	var up
	if opener.file_exists(open_str):
		up=opener.get_as_text().split(" ",true)
		opener.close()
		if up[index]=="0":  #проверка на первое улучшение
			if index==1:
				$DamageInt.text="200"
				up[1]="1"
			elif index==2:
				$HealthInt.text="1600"
				up[2]="1"
			elif index==3:
				$DefInt.text="200"
				up[3]="1"
			var saver=File.new()
			var save_str="res://txt_inventory//"+"flag"+".txt"
			saver.open(save_str,File.WRITE)
			saver.store_string(up[0]+" "+up[1]+" "+up[2]+" "+up[3])
			saver.close()
			return 1
	opener.close()
	
	var x=1.1
	opener=File.new()
	open_str="res://txt_inventory//"+"xUP"+".txt"
	opener.open(open_str,File.READ)
	if opener.file_exists(open_str):
		up=opener.get_as_text().split(" ",true)
		x=float(up[index])
		if index==1 && x==1.25:  #изменение прироста характеристик в зависимости от прокачки
			up[index]=str(1.87)
		elif index==1 && x==1.87:
			up[index]=str(1.25)
		elif index==2 && x==1.25:
			up[index]=str(2.05)
		elif index==2 && x==2.05:
			up[index]=str(1.25)
		elif index==3 && x==1.2:
			up[index]=str(2.06)
		elif index==3 && x==2.06:
			up[index]=str(1.2)
	opener.close()
	var saver=File.new()
	var save_str="res://txt_inventory//"+"xUP"+".txt"
	saver.open(save_str,File.WRITE)
	saver.store_string(up[0]+" "+up[1]+" "+up[2]+" "+up[3])
	saver.close()
	return x
#кнопка улучшения в инвенторе
func _on_upgrade1_button_down():
	if(int($gold.text)>=int($costUP1.text)):
		$gold.text=str(int($gold.text)-int($costUP1.text))
		$costUP1.text = str(int(int($costUP1.text)*1.3))
		$luckyInt.text=str(int($luckyInt.text)+1)

func _on_upgrade2_button_down():
	if(int($gold.text)>=int($costUP2.text)):
		$gold.text=str(int($gold.text)-int($costUP2.text))
		$costUP2.text = str(int($costUP2.text)*2)
		$DamageInt.text=str(int(up_stats(1)*int($DamageInt.text)))

func _on_upgrade3_button_down():
	if(int($gold.text)>=int($costUP3.text)):
		$gold.text=str(int($gold.text)-int($costUP3.text))
		$costUP3.text = str(int($costUP3.text)*2)
		$HealthInt.text=str(int(up_stats(2)*int($HealthInt.text)))
	
func _on_upgrade4_button_down():
	if(int($gold.text)>=int($costUP4.text)):
		$gold.text=str(int($gold.text)-int($costUP4.text))
		$costUP4.text = str(int($costUP4.text)*2)
		$DefInt.text=str(int(up_stats(3)*int($DefInt.text)))
