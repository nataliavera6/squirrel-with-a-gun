extends Area2D
var speed = 900
var velocity = Vector2()
signal last_enemy_killed(position)
# Called when the node enters the scene tree for the first time.

var direction := Vector2.RIGHT

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += delta * direction * speed 


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var death_position = body.global_position

		if get_tree().get_nodes_in_group("enemy").size() == 1:
			last_enemy_killed.emit(death_position)

		body.queue_free()
		queue_free()
	queue_free()
	
