extends Control

@export var food_spawner: Node

func _ready() -> void:
  $FoodButton.pressed.connect(_on_food_button_pressed)
  assert(food_spawner != null, "FoodSpawner node is not assigned in UI.gd")

func _on_food_button_pressed() -> void:
  if food_spawner:
    var viewport_size: Vector2 = get_viewport().get_visible_rect().size
    var spawn_position := Vector2(
      randf_range(viewport_size.x / 4, viewport_size.x * 3 / 4),
      0
    )
    food_spawner.spawn_food(spawn_position)
