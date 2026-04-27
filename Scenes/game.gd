extends Node2D
@onready var player = $Squirrel
@onready var screen_size = get_viewport_rect().size
var changing_level := false
var enemy_count := 2
var player_is_idle = false
@onready var timer: Timer=$Timer
@export var Item : PackedScene
var Levels = ["1","2","3","4"]
var level = Levels[0]
var checkpoint_pos: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.player_won.connect(_on_player_victory)
	player.player_died.connect(_on_player_died)
	
	player.player_moved.connect(_on_player_moved)
	player.item_collected.connect(_on_item_collected)
	if checkpoint_pos!=Vector2.ZERO:
		player.global_position=checkpoint_pos
	spawn_enemies(enemy_count)

	#player.player_won.connect(_on_player_victory)
	#level = Levels[0]
	#Levels = Levels.slice(1,-1)
	#player.player_moved.connect(_on_player_moved)
	#var enemy = preload("res://Scenes/enemy.tscn").instantiate()
	#var spawn_point: Vector2 = enemy_to_player()
	#print("Spawning Enemy at: ", spawn_point)
	#enemy.global_position = spawn_point
	#add_child(enemy)
func _process(delta: float) -> void:
	pass
		
func _on_item_collected(animation_name: String):
	print("Game received item:", animation_name)
	get_tree().paused = true
	if animation_name == "1":
		$DialogueBox.start_dialogue("You found the first item.")
	elif animation_name == "2":
		$DialogueBox.start_dialogue("You found the second item.")
	else:
		$DialogueBox.start_dialogue("You found an item.")


func _on_last_enemy_killed(item_pos: Vector2):
	spawn_item(level, item_pos)

	print(Levels)
	if Levels.size()>1:
		Levels = Levels.slice(1)
		level = Levels[0]
		print(Levels)
		checkpoint_pos=player.global_position
		changing_level = true
		print("next level")
		print(level)
		enemy_count += 1
		spawn_enemies(enemy_count)
		changing_level = false
	#else:
		#get_tree().change_scene_to_file("res://Scenes/game.tscn")
		#
func spawn_item(level, item_pos: Vector2):
	print("spawned")
	var item = preload("res://Scenes/items.tscn").instantiate()
	item.get_child(1).animation = level
	item.global_position = item_pos

	add_child(item)
	
func _on_player_died():
	remove_all_enemies()
	if checkpoint_pos!=Vector2.ZERO:
		player.global_position=checkpoint_pos
	else:
		player.global_position = Vector2(20, 20)
	spawn_enemies(enemy_count)
	
func remove_all_enemies():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
		
func spawn_enemies(amount: int) -> void:
	print(amount)
	for i in range(amount):
		var enemy = preload("res://Scenes/enemy.tscn").instantiate()
		var spawn_point: Vector2 = enemy_to_player()
		enemy.global_position = spawn_point
		add_child(enemy)
		
func _on_player_victory():
	get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")

#func _update_time_label() -> void:
	#var seconds_left := int(ceil(timer.time_left))
	#time_label.text = "Time Left: %d" % seconds_left + "s"


func _on_player_moved() -> void:
	player_is_idle = false

func enemy_to_player() -> Vector2:
	var viewport_size = get_viewport_rect().size
	var margin = 80.0

	var side = randi() % 4

	match side:
		0: # above screen
			return Vector2(randf_range(0, viewport_size.x), -margin)

		1: # below screen
			return Vector2(randf_range(0, viewport_size.x), viewport_size.y + margin)

		2: # left of screen
			return Vector2(-margin, randf_range(0, viewport_size.y))

		3: # right of screen
			return Vector2(viewport_size.x + margin, randf_range(0, viewport_size.y))

	return Vector2.ZERO
#func enemy_to_player() -> Vector2:
	#var viewport_size = get_viewport_rect().size
	#var cam = get_viewport().get_camera_2d()
	#var margin = 80.0
#
	#if cam == null:
		#var side = randi() % 4
		#match side:
			#0:
				#return Vector2(randf_range(0, viewport_size.x), -margin)
			#1:
				#return Vector2(randf_range(0, viewport_size.x), viewport_size.y + margin)
			#2:
				#return Vector2(-margin, randf_range(0, viewport_size.y))
			#3:
				#return Vector2(viewport_size.x + margin, randf_range(0, viewport_size.y))
		#return Vector2.ZERO
#
	#var half = viewport_size / 2.0
	#var left = cam.global_position.x - half.x
	#var right = cam.global_position.x + half.x
	#var top = cam.global_position.y - half.y
	#var bottom = cam.global_position.y + half.y
#
	#var side = randi() % 4
	#match side:
		#0:
			#return Vector2(randf_range(left, right), top - margin)
		#1:
			#return Vector2(randf_range(left, right), bottom + margin)
		#2:
			#return Vector2(left - margin, randf_range(top, bottom))
		#3:
			#return Vector2(right + margin, randf_range(top, bottom))
#
	#return Vector2.ZERO







func _on_interest_timeout() -> void:
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/end_screen_lose.tscn")


func _on_timer_timeout() -> void:
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")


func _on_texture_button_pressed() -> void:
	var bus := AudioServer.get_bus_index("Master")
	var muted := AudioServer.is_bus_mute(bus)
	AudioServer.set_bus_mute(bus, not muted)
