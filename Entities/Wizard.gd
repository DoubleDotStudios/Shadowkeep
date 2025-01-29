extends Boss

@onready var coll: CollisionShape2D = $CollisionShape2D

var inside: bool = false
var see: bool = true

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	nav.target_position = adventurer.global_position

func _physics_process(delta: float) -> void:
	match self.state:
		State.Prepare:
			var t = Timer.new()
			add_child(t)
			t.start(0.1)
			await t.timeout
			t.queue_free()
			self.state = State.Chase
		
		State.Defeat:
			queue_free()
		
		State.Wait:
			coll.set_deferred("disabled", true)
			nav.target_position = Vector2.ZERO
		
		State.Hit:
			if nav.target_reached:
				see = true
				$AnimationPlayer.play("Appear")
				await  $AnimationPlayer.animation_finished
				coll.set_deferred("disabled", false)
				$Hurt.set_deferred('monitoring', true)
				$Hit.set_deferred('monitoring', true)
				self.state = State.Chase
			else:
				$AnimationPlayer.play("Warp")
				see = false
				await $AnimationPlayer.animation_finished
				
				coll.set_deferred("disabled", true)
				$Hurt.set_deferred('monitoring', false)
				$Hit.set_deferred('monitoring', false)
				
				var currPos: Vector2 = global_position
				var nextPos: Vector2 = nav.get_next_path_position()
				
				velocity = currPos.direction_to(nextPos) * speed * delta * 10000
				
				move_and_slide()
		
		State.Chase:
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

func _on_damage_component_damaged() -> void:
	self.state = State.Hit
	var randomPos = NavigationServer2D.map_get_random_point(area.get_navigation_map(), 1, false)
	nav.target_position = randomPos
