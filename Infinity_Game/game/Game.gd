extends Node2D
#спавн мобов и добавление им направления и скорости
func _on_MobTimer_timeout():
	$MobTimer.start()
	$MobTimer.wait_time=2;

	var mob = load("res://game/Entity.tscn").instance()

	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	var direction = mob_spawn_location.rotation + PI / 2

	mob.position = mob_spawn_location.position

	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)
	

var hero_lucky=0
var hero_hp=0
var hero_damage=0
var hero_def=0
var hero_exp=0
var hero_lvl=0
var exp_lvl=0

var mob_hp=0
var mob_damage=0
var mob_def=0
var mob_lvl=1


func money_save():
	var saver=File.new()
	var save_str="res://txt_inventory//gold.txt"
	saver.open(save_str,File.WRITE)
	saver.store_string($Hero/HUD/money.text)
	saver.close()

func money_load():
	var opener=File.new()
	var open_str="res://txt_inventory//gold.txt"
	opener.open(open_str,File.READ)
	if opener.file_exists(open_str):
		$Hero/HUD/money.text=opener.get_as_text()
	opener.close()

func hero_load():
	var opener=File.new()
	var open_str="res://txt_fight//hero.txt"
	opener.open(open_str,File.READ)
	if opener.file_exists(open_str):
		var stats=opener.get_as_text().split(" ",true)
		hero_lucky=int(stats[0])
		hero_hp=int(stats[1])
		hero_damage=int(stats[2])
		hero_def=int(stats[3])
		hero_exp=int(stats[4])
		hero_lvl=int(stats[5])
	opener.close()

func hero_save():
	var saver=File.new()
	var save_str="res://txt_fight//hero.txt"
	saver.open(save_str,File.WRITE)
	saver.store_string(hero_lucky+" "+hero_hp+" "+hero_damage+" "+hero_def+" "+hero_exp+" "+hero_lvl)
	saver.close()




func mob_load():
	var opener=File.new()
	var open_str="res://txt_fight//mob.txt"
	opener.open(open_str,File.READ)
	if opener.file_exists(open_str):
		var stats=opener.get_as_text().split(" ",true)
		mob_hp=int(stats[0])
		mob_damage=int(stats[1])
		mob_def=int(stats[2])
	opener.close()


signal lvl_up(eexp,maxxp)
signal show(l,m)
#обработка боя
func _fight():
	hero_load()
	mob_hp=(mob_hp+100*hero_lvl)
	mob_damage=mob_damage+10*hero_lvl
	mob_def=mob_def+10*hero_lvl
	while(hero_hp>0 || mob_hp>0):
		if(rand_range(0,100)<=hero_lucky):
			mob_hp=mob_hp-((hero_damage*2)-(mob_def/10))
		else:
			mob_hp=mob_hp-(hero_damage-(mob_def/10))
		hero_hp=hero_hp-(mob_damage-(hero_def/10))
	if(mob_hp<0):
		var lvl=hero_lvl
		var money=int((7*mob_lvl)+int(rand_range(-mob_lvl,mob_lvl)))
		$Hero/HUD/money.text=str(int($Hero/HUD/money.text)+money)
		hero_exp=hero_exp+(30*mob_lvl)
		while(hero_exp>=(hero_lvl*10)+exp_lvl):
			hero_exp=hero_exp-((hero_lvl*15)+exp_lvl)
			hero_lvl=hero_lvl+1
			exp_lvl=exp_lvl+hero_lvl*15
			mob_hp=mob_hp+200
			mob_damage=mob_damage+15
			mob_def=mob_def+20
			mob_lvl=mob_lvl+1
			emit_signal("lvl_up",hero_exp,exp_lvl)   #в случае повышения уровня вызвать ф-ию в другом скрипте
		emit_signal("show",hero_lvl-lvl,money)

	elif(hero_hp<0):
		get_tree().change_scene("res://menu/Menu.tscn")
		exp_lvl=0
		delete_stats()
		
func delete_stats():
	var saver=File.new()
	var save_str="res://txt_stats//s.txt"
	saver.open(save_str,File.WRITE)
	saver.store_string("0 0 0 0")
	saver.close()

func _on_Hero_hit():
	money_save()
	_fight()


func new_game():
	money_load()
	mob_load()
	$Hero.start($StartPosition.position)
	$MobTimer.start()
	$MobTimer.wait_time=1;
	
func _ready():
	randomize()
	new_game()
