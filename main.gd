extends Node2D

signal turn_started(turn : int)
signal turn_ended(turn : int)

var current_turn : int = 0
var units : Array[Unit] = []

func switch_turn()->void:
	turn_ended.emit(current_turn)
	current_turn = 0 if current_turn else 1
	turn_started.emit(current_turn)
