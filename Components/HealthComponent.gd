class_name HealthComponent
extends Node

@export var hp = 5

signal defeat

func _process(_delta: float) -> void:
	if hp <= 0:
		emit_signal("defeat")
