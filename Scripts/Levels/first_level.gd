extends Node2D

@onready var collision_ship_type = $Area2D/CollisionShipType
@onready var label_win = $Label
@onready var label_lifes = $Lifes
@onready var label_game_over = $LabelGamerOver
@onready var label_score = $Score
@onready var label_time = $Time
@onready var label_fuel = $Fuel
@onready var timer_enemy_1 = $TimerEnemy_1
@onready var timer_enemy_2 = $TimerEnemy_2
@onready var timer_enemy_3 = $TimerEnemy_3
@onready var ship = $CharacterBody2D


@export var player_lose = false
@export var player_won = false
@export var enemies_defeated = []

enum {ENEMY_0,ENEMY_1,ENEMY_2,ENEMY_3}

var score = 0
var ship_type: int
var time_enemy_1: int
var time_enemy_2: int 
var time_enemy_3: int
var fuel_enemy_1: float = 20
var fuel_enemy_2: float =  19
var fuel_enemy_3: float = 22


const PATH_ENEMY_1: int = 17
const PATH_ENEMY_2: int = 16
const PATH_ENEMY_3: int = 21


func _ready() -> void:
	var enemies_1 = $Enemies_1
	var enemies_2 = $Enemies_2
	var enemies_3 = $Enemies_3
	
	for enemy in get_tree().get_nodes_in_group("enemies_1"):
		enemy.destroyed.connect(enemy_destroyed)
		
	for enemy_2 in enemies_2.get_children():
		if enemy_2.has_signal("destroyed"):
			enemy_2.destroyed.connect(enemy_destroyed)
			
	for enemy_3 in enemies_3.get_children():
		if enemy_3.has_signal("destroyed"):
			enemy_3.destroyed.connect(enemy_destroyed)

	#Set times for enemies
	time_enemy_1 = PATH_ENEMY_1
	time_enemy_2 = PATH_ENEMY_2
	time_enemy_3 = PATH_ENEMY_3
	
	
	timer_enemy_1.wait_time = 1
	timer_enemy_1.autostart = true
	timer_enemy_1.timeout.connect(update_timer_level)
	
	timer_enemy_2.wait_time = 1
	timer_enemy_2.autostart = true
	timer_enemy_2.timeout.connect(update_timer_level)
	
	timer_enemy_3.wait_time = 1
	timer_enemy_3.autostart = true
	timer_enemy_3.timeout.connect(update_timer_level)
	
	
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Enter") and player_lose:		
		player_lose = false
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("Enter") and player_won:		
		player_won = false
		get_tree().reload_current_scene()
		
	#Lose conditions
	if (fuel_enemy_1 <= 0 or fuel_enemy_2 <= 0 or fuel_enemy_3 <= 0 or
			time_enemy_1 <= 0 or time_enemy_2 <= 0 or time_enemy_3 <= 0):
		timer_enemy_1.stop()
		timer_enemy_2.stop()
		timer_enemy_3.stop()
		label_game_over.visible = true
		player_lose = true
		ship.velocity = Vector2.ZERO
		ship.can_move = false
	
	
		

func _on_character_body_2d_ship_converted(ship_type: int) -> void:
	collision_ship_type.set_deferred("disabled",true)	
	self.ship_type = ship_type
	match ship_type:
		ENEMY_1:			
			ship_type = ENEMY_1			
			update_timer_label(label_time,time_enemy_1)
			if timer_enemy_1.paused:
				timer_enemy_1.paused = false
			else:
				timer_enemy_1.start()
		ENEMY_2:	
			ship_type = ENEMY_2
			update_timer_label(label_time,time_enemy_2)
			if timer_enemy_2.paused:
				timer_enemy_2.paused = false
			else:
				timer_enemy_2.start()
		ENEMY_3:				
			ship_type = ENEMY_3
			update_timer_label(label_time,time_enemy_3)
			if timer_enemy_3.paused:
				timer_enemy_3.paused = false
			else:
				timer_enemy_3.start()
	


func _on_area_win_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:	
		label_win.visible = true
		body.velocity = Vector2.ZERO
		body.can_move = false
		timer_enemy_1.stop()
		timer_enemy_2.stop()
		timer_enemy_3.stop()
		player_won = true
		



func _on_character_body_2d_player_loose() -> void:
	label_game_over.visible = true
	player_lose = true

func _on_character_body_2d_player_lost_life(lifes: Variant) -> void:
	label_lifes.text = "Lifes:  " + str(lifes)
	timer_enemy_1.paused = true
	timer_enemy_2.paused = true
	timer_enemy_3.paused = true
	
func enemy_destroyed(score: int):
	var time_multiply = 0
	match ship_type:
		ENEMY_1:
			time_multiply = time_enemy_1
			update_fuel_label()			
		ENEMY_2:
			time_multiply = time_enemy_2
			update_fuel_label()			
		ENEMY_3:
			time_multiply = time_enemy_3
			update_fuel_label()			
	self.score += ( score * time_multiply)
	label_score.text = "Score:    " + str(self.score)
	
func update_timer_level():		
	match ship_type:
		ENEMY_1:
			time_enemy_1 -= 1
			update_timer_label(label_time,time_enemy_1)
		ENEMY_2:
			time_enemy_2 -= 1
			update_timer_label(label_time,time_enemy_2)
		ENEMY_3:
			time_enemy_3 -= 1
			update_timer_label(label_time,time_enemy_3)

func update_timer_label(label: Label,time : int):
	label.text = "Time:   " + str(time)
	
func update_fuel_label():
	match ship_type:
		ENEMY_1:
			fuel_enemy_1 -= 1
			label_fuel.text = "Fuel:   " + str(
				(fuel_enemy_1 * 100) / PATH_ENEMY_3 ) + "%" 
		ENEMY_2:
			fuel_enemy_2 -= 1
			label_fuel.text = "Fuel:   " + str(
				(fuel_enemy_2 * 100) / PATH_ENEMY_3)+ "%"
		ENEMY_3:
			fuel_enemy_3 -= 1
			label_fuel.text = "Fuel:   " + str(
				(fuel_enemy_3 * 100) / PATH_ENEMY_3) + "%"
	
