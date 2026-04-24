extends Node2D
@onready var player = $Squirrel
@onready var screen_size = get_viewport_rect().size

var player_is_idle = false
@onready var timer: Timer=$Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.player_won.connect(_on_player_victory)

	player.player_moved.connect(_on_player_moved)
	var enemy = preload("res://Scenes/enemy.tscn").instantiate()
	var spawn_point: Vector2 = enemy_to_player()
	print("Spawning Enemy at: ", spawn_point)
	enemy.global_position = spawn_point
	add_child(enemy)
func _process(delta: float) -> void:
	pass
	#_update_time_label()
func _on_player_victory():
	get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")

#func _update_time_label() -> void:
	#var seconds_left := int(ceil(timer.time_left))
	#time_label.text = "Time Left: %d" % seconds_left + "s"


func _on_player_moved() -> void:
	player_is_idle = false

func enemy_to_player() -> Vector2:
	var viewport_size = get_viewport_rect().size
	var cam = get_viewport().get_camera_2d()
	var margin = 80.0

	if cam == null:
		var side = randi() % 4
		match side:
			0:
				return Vector2(randf_range(0, viewport_size.x), -margin)
			1:
				return Vector2(randf_range(0, viewport_size.x), viewport_size.y + margin)
			2:
				return Vector2(-margin, randf_range(0, viewport_size.y))
			3:
				return Vector2(viewport_size.x + margin, randf_range(0, viewport_size.y))
		return Vector2.ZERO

	var half = viewport_size / 2.0
	var left = cam.global_position.x - half.x
	var right = cam.global_position.x + half.x
	var top = cam.global_position.y - half.y
	var bottom = cam.global_position.y + half.y

	var side = randi() % 4
	match side:
		0:
			return Vector2(randf_range(left, right), top - margin)
		1:
			return Vector2(randf_range(left, right), bottom + margin)
		2:
			return Vector2(left - margin, randf_range(top, bottom))
		3:
			return Vector2(right + margin, randf_range(top, bottom))

	return Vector2.ZERO







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
