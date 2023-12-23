extends CharacterBody2D
class_name Enemy

@onready var bullet_scene: PackedScene = preload("res://bullet.tscn")
@onready var shoot_timer: Timer = get_node("ShootTimer")
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var death_sound: AudioStreamPlayer2D = get_node("Sfx/DeathSound")
@onready var death_particles: GPUParticles2D = get_node("DeathParticles")

@export var score_modifier = 100
@export var speed = 10

var dir = Vector2.RIGHT
var can_move = true
var on_killed: Signal
var difficulty_modifier: int = 1
var can_advance = true

func _ready():
	speed *= difficulty_modifier
	_randomize_timer()
	shoot_timer.start()

func _physics_process(_delta):
	if can_move:
		velocity = dir * speed
		move_and_slide()

func _on_timer_timeout():
	shoot()
	_randomize_timer()

func _randomize_timer():
	shoot_timer.wait_time = randf_range(1, 60 - 10 / difficulty_modifier)
	
func advance(new_dir):
	dir = new_dir
	global_position.y += 1
	
func shoot():
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.dir = Vector2.DOWN
	bullet.group = "enemies"
	bullet.speed = bullet.speed * 0.75
	bullet.global_position = global_position
	bullet.global_position.y += 8
	
	get_parent().add_child(bullet)

func _on_area_2d_body_entered(_body):
	if can_advance:
		get_tree().call_group("enemies", "advance", -dir)
	
	can_advance = false
	await get_tree().create_timer(1.0).timeout
	can_advance = true

func destroy():
	death_sound.play()
	death_particles.emitting = true
	sprite.hide()
	set_collision_layer_value(4, false)
	await get_tree().create_timer(0.5).timeout
	on_killed.emit(score_modifier, false)
	queue_free()
