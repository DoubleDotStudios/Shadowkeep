extends Control

func _on_start_pressed() -> void:
	$AudioStreamPlayer.pitch_scale = randf_range(0.4, 0.7)
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://Places/Dungeon.tscn")

func _on_quit_pressed() -> void:
	$AudioStreamPlayer.pitch_scale = randf_range(0.4, 0.7)
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	get_tree().quit()
