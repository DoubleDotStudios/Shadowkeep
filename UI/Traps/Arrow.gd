extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: int = 5000
var damage: int = 2

var usable = false

func _ready() -> void:
	$DamageComponent.damage = damage
	
	match direction:
		Vector2(0, -1): rotation_degrees = 90 #Up
		Vector2(1, 0): rotation_degrees = 180 #Right
		Vector2(0, 1):  #Down
			rotation_degrees = -90
			$Sprite2D.flip_v = true

func _physics_process(delta: float) -> void:
	velocity = speed * direction * delta
	
	move_and_slide()
	
	if !usable:
		var timer = Timer.new()
		add_child(timer)
		
		timer.start(0.15)
		await timer.timeout
		
		usable = true
		$DamageComponent.monitoring = true
		timer.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_damage_component_attacked() -> void:
	queue_free()

func _on_damage_component_body_entered(body: Node2D) -> void:
	if body.name == "Adventurer" || body.get_class() == "TileMapLayer":
		queue_free()
