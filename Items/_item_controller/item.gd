extends RigidBody3D
class_name Item

@export var item_data: ItemData

@export_group("Mesh and Collison Node")
@export var collision_shape: CollisionShape3D 
@export var mesh: MeshInstance3D
@export var mesh_outline: MeshInstance3D 

func _ready() -> void:
	if has_meta("item_data"):
		item_data = get_meta("item_data")

	mesh.mesh = item_data.mesh
	mesh.material_override = item_data.material
	mesh_outline.mesh = item_data.mesh.create_outline(0.03)
	collision_shape.shape = item_data.shape
	



func outline_on():
	mesh_outline.visible = true

func outline_off():
	mesh_outline.visible = false
