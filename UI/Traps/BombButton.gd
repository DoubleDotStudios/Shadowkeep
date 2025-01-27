extends menuButton

enum Direction {
	Up,
	Left,
	Right,
	Down
}

@export_category("Data")
@export var direction: Direction = Direction.Right

var dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	dir = directionToVec(direction)

func directionToVec(dir: Direction):
	match dir:
		Direction.Up: return Vector2(0, -1)
		Direction.Left: return Vector2(-1, 0)
		Direction.Right: return Vector2(1, 1)
		Direction.Down: return Vector2(0, 1)
