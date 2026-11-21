extends Control


@export var World_Item: PackedScene
@export var inventory_controller: InventoryController


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if visible:
			visible = false
		else:
			visible = true


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return(true)


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var node = World_Item.instantiate()
	
	node.set_meta("item_data",data.item)
	
	get_tree().current_scene.add_child(node)
	if data.current_item_count > 1:
		data.current_item_count -= 1
	else:
		data.item = null
		data.current_item_count = 0
	node.global_position = inventory_controller.drop_position.global_position
	
	data.update_slot_ui()
