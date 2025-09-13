extends CharacterBody2D

signal ship_converted(ship_type: int)
signal player_loose
signal player_lost_life(lifes)

@onready var sprite = $Sprite2D
@onready var animation_basic = $AnimatedSprite2D
@export var speed = 200
@export var is_converted = false
@export var ship_type: int = 0
@export var can_move = true
@export var lifes: int  = 3
@export var sprite_export: Sprite2D
@export var player_loose_flag: bool = false


var lifes_handler = 3
enum {X, CIRCLE,TRIANGLE, SQUARE}
var animation_movement_running = false
func _ready() -> void:
	is_converted = false
	sprite_export = sprite
	
func get_input():
	if can_move:
		var input_direction = Input.get_vector("left","right","up","down")
		animation_basic.play("idle")
		if Input.is_action_pressed("aceleration"):			
			play_dash_animation()	
			velocity = input_direction * (speed * 2)
		else:			
			velocity = input_direction * speed
			if velocity != Vector2.ZERO:
				play_movement_animation()
			else:
				play_idle_animation()
				
				

func _physics_process(delta: float) -> void:
	if not player_loose_flag:
		get_input()
		move_and_slide()

func _process(delta: float) -> void:		
	if lifes != lifes_handler:
		lifes_handler = lifes
		player_lost_life.emit(lifes)
		ship_type = X
	if lifes == 0 and not player_loose_flag:		
		player_loose.emit()
		player_loose_flag = true
		
		
	
func _on_static_body_2d_convert_player_enemy_1(ship_type: int) -> void:			
	ship_converted.emit(ship_type)	
	
func _on_enemy_2_convert_player_enemy_2(ship_type: int) -> void:			
	ship_converted.emit(ship_type)


func _on_enemy_3_convert_player_enemy_3(ship_type: int) -> void:		
	ship_converted.emit(ship_type)

func play_movement_animation():
	match ship_type:
		X:
			animation_basic.play('ship_movement')
		CIRCLE:
			animation_basic.play("ship_movement_circle")
		TRIANGLE:
			animation_basic.play("ship_movement_triangle")
		SQUARE: 
			animation_basic.play("ship_movement_square")
						
func play_idle_animation():
	match ship_type:
		X:
			animation_basic.play('idle')
		CIRCLE:
			animation_basic.play("ship_idle_circle")
		TRIANGLE:
			animation_basic.play("idle_triangle")
		SQUARE:
			animation_basic.play('idle_square')

func play_dash_animation():
	match ship_type:
		X:
			animation_basic.play("ship_dash")
		CIRCLE:
			animation_basic.play("ship_dash_circle")
		TRIANGLE:
			animation_basic.play("ship_dash_triangle")
		SQUARE: 
			animation_basic.play("ship_dash_square")
			
