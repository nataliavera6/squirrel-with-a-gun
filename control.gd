extends Control

@onready var video = $VideoStreamPlayer
@onready var fade_rect = $ColorRect

# =========================
# READY
# =========================
func _ready():
	print("End scene loaded")

	# start black screen
	fade_rect.color.a = 1.0

	# IMPORTANT: DO NOT preload .ogv manually
	# just assign it in the Inspector instead (see note below)

	video.play()

	fade_in()


# =========================
# FADE IN
# =========================
func fade_in():
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 2.0)


# =========================
# VIDEO FINISHED SIGNAL
# =========================
func _on_VideoStreamPlayer_finished():
	print("Video finished")
	fade_out()


# =========================
# FADE OUT
# =========================
func fade_out():
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, 2.0)
	tween.tween_callback(Callable(self, "_go_to_menu"))


# =========================
# MENU
# =========================
func _go_to_menu():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
