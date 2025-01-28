extends Boss

@onready var coll: CollisionShape2D = $CollisionShape2D

var inside: bool = false

func _ready() -> void:
	nav.target_position = adventurer.global_position

func _physics_process(delta: float) -> void:
	if self.state == State.Prepare:
		var t = Timer.new()
		add_child(t)
		t.start(0.1)
		await t.timeout
		t.queue_free()
		self.state = State.Chase
	
	if self.state == State.Defeat:
		queue_free()
	
	elif self.state == State.Wait:
		coll.set_deferred("disabled", true)
		nav.target_position = Vector2.ZERO
	elif self.state == State.Hit:
		if nav.target_reached:
			self.state = State.Chase
		
		coll.set_deferred("disabled", true)
		$DamageComponent/AreaShape.set_deferred("disabled", true)
		runAway()
		
		var currPos: Vector2 = global_position
		var nextPos: Vector2 = nav.get_next_path_position()
		
		velocity = currPos.direction_to(nextPos) * speed * delta
		
		move_and_slide()
	elif self.state == State.Chase:
		coll.set_deferred("disabled", false)
		
		var currPos: Vector2 = global_position
		var nextPos: Vector2 = nav.get_next_path_position()
		
		nav.target_position = adventurer.global_position
		
		velocity = currPos.direction_to(nextPos) * speed * delta
		
		move_and_slide()

func _on_damage_component_attacked() -> void:
	self.state = State.Hit

func runAway() -> void:
	var adventurerPos: Vector2 = adventurer.global_position
	var targetPos: Vector2 = ((global_position - adventurerPos) * -1).normalized()
	
	targetPos.x *= randi_range(40, 100)
	targetPos.y *= randi_range(40, 100)
	
	nav.target_position = targetPos

func _on_health_component_defeat() -> void:
	self.state = State.Defeat


func _on_damage_component_2_damaged() -> void:
	queue_free()
