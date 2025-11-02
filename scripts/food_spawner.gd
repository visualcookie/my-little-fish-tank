extends Node

@export var food_scene: PackedScene

signal food_spawned

func _ready() -> void:
  assert(food_scene != null, "Food scene is not assigned in FoodSpawner.gd")

func spawn_food(position: Vector2) -> void:
  var food = food_scene.instantiate()
  get_tree().root.add_child(food)
  food.global_position = position
  food_spawned.emit()
  Log.info("Food spawned at position: %s" % position)
