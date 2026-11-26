extends CharacterBody3D

const speed = 3.0
const attackrange = 2.0
const damage: int = 10

var  hp = 100
var player = null
var OnCooldown = false
var Bounty = 5

@export var player_path : NodePath
@export var navigation_agent_3d: NavigationAgent3D 
@export var attack_cooldown: Timer 
@export var chase_area: Area3D

enum State {
	IDLE,
	CHASE,
	ATTACK,
}

var current_state = State.IDLE


func _physics_process(_delta: float) -> void:
	var target: CharacterBody3D = find_target()
	match current_state:
		State.IDLE:
			if target:
				zwitch_state(State.CHASE)
			velocity = Vector3(0,0,0)
		State.CHASE:
			if not target:
				zwitch_state(State.IDLE)
				return
			if global_position.distance_to(target.global_position) <= attackrange:
				zwitch_state(State.ATTACK)
			chase_target(target)
		State.ATTACK:
			if not global_position.distance_to(target.global_position) <= attackrange:
				zwitch_state(State.CHASE)
			attack_player(target)
	
	move_and_slide()


func attack_player(target: CharacterBody3D) -> void:
	var hp_node: Hp = target.find_child("Hp")
	print(target)
	hp_node.tackig_damige(damage)


func chase_target(target: CharacterBody3D) -> void:
	var target_position: Vector3 = target.global_position
	var direction_to_target: Vector3 = target.global_position - global_position
	# look at target
	var target_flat_position = Vector3(target_position.x, global_position.y, target_position.z)
	if global_position.distance_to(target_flat_position) > 0.1:
		look_at(target_flat_position, Vector3.UP)
	
	# chase target
	direction_to_target = direction_to_target.normalized()
	velocity = direction_to_target * speed


func find_target() -> CharacterBody3D:
	var bodys = chase_area.get_overlapping_bodies()
	if bodys == null:
		return null
	var potential_target: Array
	
	# Find potential_target
	for i in bodys.size():
		if not bodys[i].get_groups() == get_groups() and bodys[i] is CharacterBody3D:
			potential_target.append(bodys[i])
	
	var nearest_target: CharacterBody3D
	var distance_to_nearest_target: float = 999
	
	for i in potential_target.size():
		if distance_to_nearest_target >= global_position.distance_to(potential_target[i].global_position):
			distance_to_nearest_target = global_position.distance_to(potential_target[i].global_position)
			nearest_target = potential_target[i]
	
	return nearest_target


func zwitch_state(to_state) -> void:
	if current_state == to_state:
		return
	
	current_state = to_state


func _on_hp_die() -> void:
	print("die")
