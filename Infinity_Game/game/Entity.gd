extends RigidBody2D

#создание сцены и выбор одного из видов мобов  
func _ready():
	$Entity.playing = true
	var mob_types = $Entity.frames.get_animation_names()
	$Entity.animation = mob_types[randi() % mob_types.size()]

#при выходе за пределы экрана удаление 
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

