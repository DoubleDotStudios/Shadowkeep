class_name menuButton
extends Button

@onready var inactive: NinePatchRect = $Inactive
@onready var active: NinePatchRect = $Active

func _on_mouse_entered() -> void:
	active.visible = true
	inactive.visible = false

func _on_mouse_exited() -> void:
	active.visible = false
	inactive.visible = true

func _on_button_down() -> void:
	active.modulate = Color("#a8a8a8")

func _on_button_up() -> void:
	active.modulate = Color("#fff")
