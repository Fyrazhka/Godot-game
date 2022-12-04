extends Area2D

signal hit
const speed=300
var velocity=Vector2()

#обработка движений 
func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		velocity.x=-speed
		$AnimatedHero.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x=speed
		$AnimatedHero.flip_h = false
	elif Input.is_action_pressed("ui_up"):
		velocity.y=-speed
	elif Input.is_action_pressed("ui_down"):
		velocity.y=speed
	else:
		velocity.x=0
		velocity.y=0
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedHero.play("walk")
	else:
		$AnimatedHero.play("stay")
		
	position += velocity * delta
	position.x = clamp(position.x, -558, 1280)
	position.y = clamp(position.y, -500, 720)

func start(pos):
	position = pos
	show()
	load_stats()
	$CollisionShape2D.disabled = false

func save_to_fight():
	hud_load()
	var saver=File.new()
	var save_str="res://txt_fight//hero.txt"
	saver.open(save_str,File.WRITE)
	saver.store_string(str(lucky)+" "+str(hp+up_hp)+" "+str(damage+up_damage)+" "+str(def+up_def)+" "+str(Exp)+" "+str(lvl))
	saver.close()

func load_after_fight():
	var opener=File.new()
	var open_str="res://txt_fight//hero.txt"
	opener.open(open_str,File.READ)
	if opener.file_exists(open_str):
		var stats=opener.get_as_text().split(" ",true)
		Exp=int(stats[4])
		lvl=int(stats[5])
	opener.close()

#если мы касаемся моба
func _on_Hero_body_entered(body):
	#hide()
	save_to_fight()
	emit_signal("hit")
	body.queue_free()
	load_after_fight()
	#$CollisionShape2D.set_deferred("disabled", true)

var up_hp=0
var up_damage=0
var up_def=0


var hp=0
var damage=0
var def=0
var lucky=0

var Exp=0
var lvl=1#int($HUD/lvl.text)



func load_stats():
	var opener=File.new()
	var open_str="res://txt_inventory//stats.txt"
	opener.open(open_str,File.READ)
	if opener.file_exists(open_str):
			var stats=opener.get_as_text().split(" ",true)
			lucky=int(stats[0])
			damage=int(stats[1])
			hp=int(stats[2])
			def=int(stats[3])
	opener.close()




func hud_load():
	var opener=File.new()
	var open_str="res://txt_stats//s.txt"
	opener.open(open_str,File.READ)
	if opener.file_exists(open_str):
		var stats=opener.get_as_text().split(" ",true)
		up_hp=int(stats[1])+600
		up_damage=int(stats[2])+105
		up_def=int(stats[3])+10
	opener.close()
