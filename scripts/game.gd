extends Node2D

@onready var enemy_scene: PackedScene = preload("res://enemy.tscn")
@onready var mothership_scene: PackedScene = preload("res://mothership.tscn")
@onready var enemy_container = get_node("EnemyContainer")
@onready var player_score = get_node("PlayerScore")
@onready var extra_life_container = get_node("Control/HBoxContainer")
@onready var spaceship = get_node("Spaceship")
@onready var extra_life_scene = preload("res://extra_life.tscn")
@onready var defeat_menu_scene = preload("res://defeat_menu.tscn")

var level = 1
var lives = 3
var enemy_count = 0

signal enemy_killed(score_modifier: int, )
signal player_killed

func _ready():
	_randomize_spawn_mothership()
	_spawn_enemies()
	enemy_killed.connect(_on_enemy_killed)
	player_killed.connect(_on_player_killed)
	
	for i in range(lives):
		var extra_life = extra_life_scene.instantiate()
		extra_life_container.add_child(extra_life)

func _spawn_enemies():
	for row in range(3):
		for cell in range(8):
			var enemy: Enemy = enemy_scene.instantiate()
			enemy.on_killed = enemy_killed
			enemy.difficulty_modifier = level
			enemy.global_position = Vector2(cell * 16 + 8, (1 + row) * 16 + 8)
			enemy_container.add_child(enemy)
			enemy_count += 1

func _on_enemy_killed(score_modifier: int, is_special_enemy: bool):
	_update_score(score_modifier)
	if not is_special_enemy:
		enemy_count -= 1

	if enemy_count == 0:
		level += 1
		_spawn_enemies()

func _update_score(score_modifier: int):
	player_score.text = str(int(player_score.text) + score_modifier)

func _on_player_killed():
	if lives > 0:
		lives -= 1
		extra_life_container.remove_child(extra_life_container.get_child(0))
		spaceship.global_position = Vector2(80, 104)
	else:
		get_tree().paused = true
		
		var defeat_menu = defeat_menu_scene.instantiate()
		get_node("Control").add_child(defeat_menu)
		
		var retry_button: Button = defeat_menu.get_node("Panel/Button")
		retry_button.grab_focus()
		retry_button.connect("pressed", retry)

func retry():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _randomize_spawn_mothership():
	var timer = get_node("Timer")
	timer.wait_time = randf_range(5, 15)
	timer.start()

func _on_timer_timeout():
	_randomize_spawn_mothership()
	var mothership = mothership_scene.instantiate()
	mothership.global_position = Vector2(8,8)
	mothership.on_killed = enemy_killed
	
	add_child(mothership)
