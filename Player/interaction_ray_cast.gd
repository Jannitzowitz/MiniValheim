extends RayCast3D

@export var inventory_controller: InventoryController

var collider: Node3D
var can_interact: bool
var potential_object: RigidBody3D


func _process(_delta: float) -> void:
	can_interact = false
	if collide_with_bodies:
		collider = get_collider()
		if collider and  collider is Item:
			can_interact = true
			collider.outline_on()
			potential_object = collider
		elif potential_object and collider != potential_object:
			can_interact = false
			potential_object.outline_off()
			can_interact = false
		



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if can_interact:
			inventory_controller.add_item(potential_object)
			potential_object = null
