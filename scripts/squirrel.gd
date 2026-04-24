extends CharacterBody2D

var moving := false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var screen_size = get_viewport_rect().size
signal player_won
signal player_idle
signal player_moved

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")

	velocity = direction * SPEED
	
	move_and_slide()
	position = position.clamp(Vector2(20,20), Vector2(screen_size.x - 20,screen_size.y - 20))
	moving = direction != Vector2.ZERO
	animation_handler(direction)
	if !moving:
		player_idle.emit()
	elif moving:
		player_moved.emit()

func animation_handler(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				$AnimatedSprite2D.play("right")
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.play("left")
				$AnimatedSprite2D.flip_h = true
		else:
			if direction.y > 0:
				$AnimatedSprite2D.play("down")
			else:
				$AnimatedSprite2D.play("up")
	else:
		$AnimatedSprite2D.play("idle")
		
		

		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("dead")
		
		body.queue_free()
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
