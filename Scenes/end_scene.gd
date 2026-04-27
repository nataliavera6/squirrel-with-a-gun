extends Control

@onready var video = $VideoStreamPlayer
@onready var fade_rect = $ColorRect

func _ready():
	fade_rect.color.a = 1.0
	video.play()
	fade_in()


func fade_in():
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 1.5)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               


func _on_VideoStreamPlayer_finished():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
