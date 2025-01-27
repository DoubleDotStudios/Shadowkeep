class_name Boss
extends CharacterBody2D

@export_category("Data")
@export var speed: float = 850
@export var adventurer: Adventurer = null

@onready var nav: NavigationAgent2D = $NavigationAgent2D

enum State {
	Chase,
	moveSpecial,
	Attack,
	attackSpecial,
	
	Wait,
	Hit,
	Hurt,
	
	Prepare,
	Defeat
}

var state: State = State.Prepare
