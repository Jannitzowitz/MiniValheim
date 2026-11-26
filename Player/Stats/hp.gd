extends Node
class_name Hp

@export var hp: int

signal die
var is_dead: bool = false

func tackig_damige(damige: int) -> bool:
	hp -= damige
	print(hp)
	if hp == 0 or hp < 0:
		emit_signal("die")
		return true
	else:
		return false
