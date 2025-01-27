class_name DamageComponent
extends Area2D

@export var health: HealthComponent = null
@export_enum("Hit", "Hurt") var type = "Hurt"
@export var damage: int = 0

signal attacked
signal damaged

func hurt(area: Area2D):
	health.hp -= area.damage
	emit_signal("damaged")

func hit(area: Area2D):
	area.health.hp -= damage
	emit_signal("attacked")

func _on_area_entered(area: Area2D) -> void:
	if area.name == "DamageComponent":
		if type == "Hurt" && area.type == "Hit": hurt(area)
		elif type == "Hit" && area.type == "Hurt": hit(area)
