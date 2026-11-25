extends Control
class_name InventorySlot


@export var World_Item: PackedScene
@export var texture_rect: TextureRect 
@export var label: Label 


var slot_index:int
var current_item_count: int = 0
var item: ItemData



func add_item(itemdata):
	item = itemdata.item_data
	current_item_count += 1
	update_slot_ui()


func _on_pressed() -> void:
	if current_item_count > 0:
		if item.typ == item.ItemTyp.WEAPON or item.typ == item.ItemTyp.WEAPON:
			print("Ausgerüstet Waffe/Toll")


func is_slot_free(itemdata) :
	if current_item_count > 0:
		if item.name == itemdata.item_data.name:        
			if current_item_count < item.stack_size:
				return true
	elif current_item_count == 0:
		return true
	else:
		return false


func update_slot_ui() -> void:
	if current_item_count == 0:
		texture_rect.texture = null
		label.text = ""
	else:
		texture_rect.texture = item.icon
		label.text = str(current_item_count)






func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item:
		return
		
	var preview = duplicate()
	var c = Control.new()
	c.add_child(preview)
	preview.position -= Vector2(25,25)
	preview.self_modulate = Color.TRANSPARENT
	c.modulate = Color(c.modulate,0.5)
	
	set_drag_preview(c)
	return self


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is InventorySlot:
		return(true)
	return(false)


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var tmp = item
	item = data.item
	
	var tmp_count = current_item_count
	current_item_count = data.current_item_count
	data.current_item_count = tmp_count
	
	data.item = tmp
	texture_rect.show()
	
	data.texture_rect.show()
	update_slot_ui()
	data.update_slot_ui()
