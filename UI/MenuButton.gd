class_name menuButton
extends Button

@onready var inactive: NinePatchRect = $Inactive
@onready var active: NinePatchRect = $Active

@export var sfx: AudioStreamPlayer = null

func _on_mouse_entered() -> void:
	sfx.pitch_scale = randf_range(1.2, 1.7)
	sfx.play()
	active.visible = true
	inactive.visible = false

func _on_mouse_exited() -> void:
	active.visible = false
	inactive.visible = true

func _on_button_down() -> void:
	active.modulate = Color("#a8a8a8")

func _on_button_up() -> void:
	active.modulate = Color("#fff")
