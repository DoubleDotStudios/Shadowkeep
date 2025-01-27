extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: int = 5000
var damage: int = 2

func _ready() -> void:
	$DamageComponent.damage = damage
	
	match direction:
		Vector2(0, -1): $Sprite2D.rotation_degrees = 90 #Up
		Vector2(1, 0): $Sprite2D.flip_h = true #Right
		Vector2(0, 1):  #Down
			$Sprite2D.rotation_degrees = -90
			$Sprite2D.flip_v = true

func _process(delta: float) -> void:
	velocity = speed * direction * delta
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
