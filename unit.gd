class_name Unit extends Sprite2D

signal turn_started
signal turn_ended

var toggle = false

func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = preload("uid://dd0eyqwoi1qer")
	turn_started.connect(_on_turn_started)
	turn_ended.connect(_on_turn_ended)
	
func _on_turn_started()->void:
	material.set_shader_parameter("enable", true)
	pass
func _on_turn_ended()->void:
	material.set_shader_parameter("enable", false)
	pass
