@icon("res://at-icons_v1.3.0/addons/at-icons/node/grid_coarse.svg")
extends Node
class_name InventoryController

@export var inventory_ui: Control
@export var inventory_grid: GridContainer
@export var inventory_slot_count: int 
@export var inventory_slot_prefab: PackedScene

@export_category("PlayerComponent")
@export var interaction_ray_cast: RayCast3D
@export var weapon_controller: Node3D
@export var drop_position: Marker3D

var inventory_slot: Array[InventorySlot] ## saves all Slots

func _ready() -> void:
	create_slots()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if inventory_ui.visible == true:
			inventory_ui.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			inventory_ui.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

## -creates the slots [br]
## -the number of slots == inventory_slot_count
func create_slots() -> void:
		for i in inventory_slot_count:
			var slot = inventory_slot_prefab.instantiate() as InventorySlot
			inventory_grid.add_child(slot)
			inventory_slot.append(slot)

func add_item(item) -> void:
	print(item)
	for i in inventory_slot_count:
		var free = inventory_slot[i].is_slot_free(item)
		if free:
			inventory_slot[i].add_item(item)
			item.queue_free()
			return
