extends CharacterBody2D
var is_shooting :=false
var moving := false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var screen_size = get_viewport_rect().size
signal player_won
signal player_idle
signal player_moved
signal item_pos
signal item_collected(animation_name: String)
@export var Bullet : PackedScene
signal player_died
var facing_direction = Vector2.RIGHT
func _physics_process(delta: float) -> void:
	is_shooting = false
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	var shoot_direction := Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down")
	if direction != Vector2.ZERO:
		facing_direction = direction.normalized()


	
	if Input.is_action_just_pressed("shoot_left") \
	or Input.is_action_just_pressed("shoot_right") \
	or Input.is_action_just_pressed("shoot_up") \
	or Input.is_action_just_pressed("shoot_down"):
		animation_handler(shoot_direction)
		shoot(shoot_direction.normalized())
		is_shooting=true
		
	elif Input.is_action_just_pressed("shoot"):
		shoot(facing_direction)
	
	velocity = direction * SPEED
	
	move_and_slide()
	position = position.clamp(Vector2(20,20), Vector2(screen_size.x - 20,screen_size.y - 20))
	moving = direction != Vector2.ZERO
	if !is_shooting:
		animation_handler(direction)
	if !moving:
		player_idle.emit()
	elif moving:
		player_moved.emit()

func shoot(direction: Vector2):
	if direction==Vector2.ZERO:
		return
	var b = Bullet.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = global_position
	b.direction = direction
	b.last_enemy_killed.connect(get_tree().current_scene._on_last_enemy_killed)
	
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
		var death_position = body.global_position
		body.queue_free()
		player_died.emit()

		#get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif body.is_in_group("item"):
		var animation_name = body.get_node("AnimatedSprite2D").animation
		body.queue_free()
		item_collected.emit(animation_name)
			
		#queue_free()
		
