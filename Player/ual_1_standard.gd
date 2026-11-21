extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Idle")


func idle() -> void:
	animation_player.play("Idle")

func walk() -> void:
	animation_player.play("Walk")

func sprint() -> void:
	animation_player.play("Sprint")

func crouch_idle() -> void:
	animation_player.play("Crouch_Idle")

func crouch_walk() -> void:
	animation_player.play("Crouch_Fwd")

func fall() -> void:
	animation_player.play("Jump")

func jump() -> void:
	animation_player.play("Jump_Start")
