extends Control


@export var World_Item: PackedScene
@export var inventory_controller: InventoryController



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if visible:
			visible = false
		else:
			visible = true


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is InventorySlot:
		return(true)
	return(false)

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var node = World_Item.instantiate()
	var richtung: Vector3 = inventory_controller.drop_position.global_transform.basis.z
	
	node.set_meta("item_data",data.item)
	
	get_tree().current_scene.add_child(node)
	if data.current_item_count > 1:
		data.current_item_count -= 1
	else:
		data.item = null
		data.current_item_count = 0
	node.global_position = inventory_controller.drop_position.global_position
	node.linear_velocity = richtung * 10
	
	data.update_slot_ui()
