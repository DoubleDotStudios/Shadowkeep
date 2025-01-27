class_name DamageComponent
extends Area2D

@export var health: HealthComponent = null
@export_enum("Hit", "Hurt") var type = "Hurt"
@export var damage: int = 0

signal attacked()
signal damaged()


func hurt(area: Area2D):
	self.health.hp -= area.damage
	self.damaged.emit()

func hit(area: Area2D):
	area.health.hp -= self.damage
	self.attacked.emit()

func _on_area_entered(area: Area2D) -> void:
	if area.name.contains("DamageComponent"):
		if self.type == "Hurt" && area.type == "Hit": hurt(area)
		elif self.type == "Hit" && area.type == "Hurt": hit(area)
