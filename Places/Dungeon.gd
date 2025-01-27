extends Node2D

@onready var room0: Node2D = $"Room 0"
@onready var room1: Node2D = $"Room 1"
@onready var room2: Node2D = $"Room 2"
@onready var room3: Node2D = $"Room 3"
@onready var room4: Node2D = $"Room 4"

@onready var adventurer: Adventurer = $Adventurer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#region Show Rooms
func _on_v_0_screen_entered() -> void:
	room0.visible = true

func _on_v_1_screen_entered() -> void:
	room1.visible = true

func _on_v_2_screen_entered() -> void:
	room2.visible = true

func _on_v_3_screen_entered() -> void:
	room3.visible = true

func _on_v_4_screen_entered() -> void:
	room4.visible = true
#endregion

#region Hide Rooms
func _on_v_0_screen_exited() -> void:
	room0.visible = false

func _on_v_1_screen_exited() -> void:
	room1.visible = false

func _on_v_2_screen_exited() -> void:
	room2.visible = false

func _on_v_3_screen_exited() -> void:
	room3.visible = false

func _on_v_4_screen_exited() -> void:
	room4.visible = false
#endregion
