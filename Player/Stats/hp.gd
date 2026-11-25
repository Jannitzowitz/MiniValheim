extends Node

@export var hp: int

signal die
var is_dead: bool = false

func tackig_damige(damige) -> bool:
	hp -= damige
	if hp == 0 or hp < 0:
		emit_signal("die")
		return true
	else:
		return false
