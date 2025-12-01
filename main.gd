extends Node2D

signal turn_started(turn : int)
signal turn_ended(turn : int)

var current_turn : int = 0
var units : Array[Unit] = []

func _ready() -> void:
	units.append($Skeleton)
	units.append($Slime)

func switch_turn()->void:
	turn_ended.emit(current_turn)
	units[current_turn].turn_ended.emit()
	current_turn = 0 if current_turn else 1
	turn_started.emit(current_turn)
	units[current_turn].turn_started.emit()

func _process(delta: float) -> void:
	if randi_range(0, 100)<3:
		switch_turn()
