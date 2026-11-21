@tool
extends Resource
class_name ItemData

enum ItemTyp {
	MATERIAL,
	CONSUMABLE,
	TOOL,
	WEAPON,
	EQUIPMENT,
	MISC,
}

# --- Information ---
@export var id: String
@export var name: String
@export var typ: ItemTyp :
	set(value):
		typ = value
		notify_property_list_changed()
@export_multiline var description: String


# --- Stats ---
@export_category("Stats")
@export var healing: int
@export var damage: int
@export var stack_size: int 
@export var durability: int

# --- Visuals ---
@export_group("Visuals")
@export var icon: Texture2D
@export var material: StandardMaterial3D
@export var mesh: Mesh


# --- Physics ---
@export_group("Physics")
@export var shape: Shape3D
@export var mass: float


func _validate_property(property: Dictionary) -> void:
	if property.name == "healing" and typ != ItemTyp.CONSUMABLE:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	
	if property.name == "damage" and typ != ItemTyp.WEAPON:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	
	if property.name == "stack_size" and typ != ItemTyp.MATERIAL and typ != ItemTyp.CONSUMABLE:
		property.usage = PROPERTY_USAGE_NO_EDITOR
		stack_size = 1
	
	if property.name == "durability" and typ != ItemTyp.TOOL and typ != ItemTyp.WEAPON and typ != ItemTyp.EQUIPMENT:
		property.usage = PROPERTY_USAGE_NO_EDITOR
