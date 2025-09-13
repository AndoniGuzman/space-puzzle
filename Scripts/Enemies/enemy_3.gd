extends Area2D

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
signal convert_player_enemy_3(ship_type: int)
signal destroyed(score)

const ENEMY_TYPE = 3
const SCORE = 50

var array_assets_variations = ["res://Assets/enemies/enemy_3_variation_1.png",
							"res://Assets/enemies/enemy_3_variation_2.png",
							"res://Assets/enemies/enemy_3_variation_3.png",
							"res://Assets/enemies/enemy_3_variation_4.png",
							"res://Assets/enemies/enemy_3_variation_5.png",
							"res://Assets/enemies/enemy_3_variation_6.png",
							"res://Assets/enemies/enemy_3_variation_7.png"]

var is_selection_enemy: bool = false
var explosion_scene = preload("res://Scenes/explosion.tscn")

func _process(delta: float) -> void:
	rotation += randf_range(.5,2) * delta
func _ready() -> void:
	sprite.texture = load(array_assets_variations[randi_range(0,6)])
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if not body.is_converted:
			convert_player_enemy_3.emit(ENEMY_TYPE)
			body.is_converted = true
			body.ship_type = ENEMY_TYPE
			is_selection_enemy = true
			
		if body.ship_type != ENEMY_TYPE:
			if not is_selection_enemy:						
				body.position = Vector2(180,600)
				body.lifes -= 1
				body.is_converted = false		
				queue_free()
		else:
			if not is_selection_enemy:
				var explosion  = explosion_scene.instantiate()
				explosion.global_position = global_position
				get_parent().add_child(explosion)											
				explosion.emitting = true
				destroyed.emit(SCORE)
				queue_free()
