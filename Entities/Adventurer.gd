## Character body that implements a movement algorithm.
##
## Used for entities that are not controlled by the payer but need movement logic.
class_name Adventurer
extends CharacterBody2D

#region Data
@export_category("Data")
## Set the adventurer's look.
@export_range(1, 4) var look: int = 1
## Set the adventurer's health.
@export var health: int = 5
## Set the adventurer's speed.
@export var speed: int = 800
## Set the adventurer's speed modifier.
@export var speed_mod: float = 1
## The navigation region that the agent connects to.
@export var area: NavigationRegion2D = null
## Target position for the nav agent.
@export var target: Node2D = null
## Toggle random navigation.
@export var navigating: bool = false
## Toggle the physics process
@export var started: bool = false
#endregion

#region Nodes
## The sprite used to display the player's look.
@onready var sprite: Sprite2D = $Sprite2D
## The navigation agent for the adventurer.
@onready var agent: NavigationAgent2D = $Agent
#endregion

enum concernLevel {
	None,
	Low,
	Medium,
	High
}

var concern: concernLevel = concernLevel.None

func _ready() -> void:
	match look:
		1: sprite.frame = 0
		2: sprite.frame = 1
		3: sprite.frame = 2
		4: sprite.frame = 3

func _process(delta: float) -> void:
	if started:
		$AnimationTree.active = true
		
		if velocity == Vector2.ZERO:
			$AnimationTree.set("parameters/blend_position", -1)
		else:
			if speed_mod == 1.5:
				$AnimationTree.set("parameters/blend_position", 1)
			elif speed_mod == 1.35:
				$AnimationTree.set("parameters/blend_position", 0.39)
			elif speed_mod == 1.2:
				$AnimationTree.set("parameters/blend_position", 0.2)
			elif speed_mod == 1:
				$AnimationTree.set("parameters/blend_position", -0.39)
		
		if target && !area:
			agent.target_position = target.global_position
			
			var currPos: Vector2 = global_position
			var nextPos: Vector2 = agent.get_next_path_position()
			
			velocity = currPos.direction_to(nextPos) * speed * delta * speed_mod
		
		if navigating:
			getRandomPos()
			
			var currPos: Vector2 = global_position
			var nextPos: Vector2 = agent.get_next_path_position()
			
			velocity = currPos.direction_to(nextPos) * speed * speed_mod * delta
		
		move_and_slide()
	else:
		$AnimationTree.active = false

func getRandomPos() -> void:
	if agent.is_navigation_finished():
		var randomPos = NavigationServer2D.map_get_random_point(area.get_navigation_map(), 1, false)
		agent.target_position = randomPos

func runAway(boss: Node2D) -> void:
	var bossPos: Vector2 = boss.global_position
	var targetPos: Vector2 = ((global_position - bossPos) * -1).normalized()
	
	targetPos.x *= randi_range(40, 100)
	targetPos.y *= randi_range(40, 100)
	
	agent.target_position = targetPos

#region Signals
func _on_close_body_entered(body: Node2D) -> void:
	if body.get_class() == "TileMapLayer" && started && navigating:
		var randomPos = NavigationServer2D.map_get_random_point(area.get_navigation_map(), 1, false)
		agent.target_position = randomPos
	if body.is_in_group("Boss"):
		concern = concernLevel.High
		speed_mod = 1.5
		runAway(body)

func _on_close_body_exited(body: Node2D) -> void:
	if body.is_in_group("Boss"):
		concern = concernLevel.Medium
		speed_mod = 1.35

func _on_medium_body_entered(body: Node2D) -> void:
	if body.is_in_group("Boss"):
		concern = concernLevel.Medium
		speed_mod = 1.35
		runAway(body)

func _on_medium_body_exited(body: Node2D) -> void:
	if body.is_in_group("Boss"):
		concern = concernLevel.Low
		speed_mod = 1.2

func _on_far_body_entered(body: Node2D) -> void:
	if body.is_in_group("Boss"):
		concern = concernLevel.Low
		speed_mod = 1.2
		runAway(body)

func _on_far_body_exited(body: Node2D) -> void:
	if body.is_in_group("Boss"):
		concern = concernLevel.None
		speed_mod = 1
#endregion


func _on_damage_component_damaged() -> void:
	$AnimationTree.active = false
	$AnimationPlayer.call_deferred("play", "Hit")
	$AnimationTree.active = true
