extends CharacterBody2D
class_name Spaceship

const SPEED = 120
var can_move = true
var can_attack = true

@onready var bullet_scene: PackedScene = preload("res://bullet.tscn")
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var shoot_sound: AudioStreamPlayer2D = get_node("Sfx/ShootSound")
@onready var death_sound: AudioStreamPlayer2D = get_node("Sfx/DeathSound")

func _physics_process(_delta):
	if can_move:
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity.x = input_direction.x * SPEED

		move_and_slide()
	
	if can_attack:
		if Input.is_action_just_pressed("ui_accept"):
			shoot()

func shoot():
	shoot_sound.play()
	var bullet = bullet_scene.instantiate()
	bullet.group = "player"
	bullet.global_position = global_position
	bullet.global_position.y -= 8
	get_parent().add_child(bullet)

func destroy():
	death_sound.play()
	get_parent().player_killed.emit()
