extends Control

func _ready():
	$Button.pressed.connect(_on_start_pressed)


func _on_start_pressed():
	print("Starting game...")
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
 
