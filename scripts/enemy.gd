extends CharacterBody2D



const JUMP_VELOCITY = -400.0
const SPEED := 125.0
@onready var jumps : int = 3
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var moving : bool = false
@onready var screen_size = get_viewport_rect().size

#const speed = 150

func _physics_process(delta: float) -> void:
	#if sprite.frame == 2:
		#sprite.stop()
		#moving = false

	
	if moving:
		var dir := global_position.direction_to(player.global_position)

		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				if sprite.animation != "right":
					sprite.play("right")
					$AnimatedSprite2D.flip_h=false
			else:
				#print("left")
				if sprite.animation != "right":
					sprite.play("right")
					$AnimatedSprite2D.flip_h=true
		else:
			if dir.y > 0:
				if sprite.animation != "down":
					sprite.play("down")
			else:
				if sprite.animation != "up":
					sprite.play("up")


		velocity = dir * SPEED 
		move_and_slide()


func _on_timer_timeout() -> void:
	
	sprite.play("idle")
	jumps -= 1
	moving = true
