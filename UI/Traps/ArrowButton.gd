extends menuButton

enum Direction {
	Up,
	Left,
	Right,
	Down
}

@export_category("Data")
@export var direction: Direction = Direction.Right

const Arrow = preload("res://UI/Traps/Arrow.tscn")

var dir: Vector2 = Vector2.ZERO
var usable: bool = true

func _ready() -> void:
	dir = directionToVec(direction)

func directionToVec(direction: Direction):
	match direction:
		Direction.Up: return Vector2(0, -1)
		Direction.Left: return Vector2(-1, 0)
		Direction.Right: return Vector2(1, 0)
		Direction.Down: return Vector2(0, 1)

func _on_pressed() -> void:
	if usable:
		var arrow = Arrow.instantiate()
		arrow.direction = dir
		arrow.global_position = $FirePoint.global_position
		
		get_parent().get_parent().add_child(arrow)
		
		usable = false
		var timer: Timer = Timer.new()
		add_child(timer)
		timer.start(1)
		
		$Disabled.visible = true
		await timer.timeout
		$Disabled.visible = false
		
		timer.queue_free()
		usable = true
