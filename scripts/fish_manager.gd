extends Node

@export var fish_scene: PackedScene

# Max allowed fish
const MAX_FISH: int = 20
const INITIAL_FISH: int = 3

# Current amount of fish inside tank
var fish_count: int = 0

func _ready() -> void:
  for i in range(INITIAL_FISH):
    spawn_fish()

func spawn_fish() -> void:
  if fish_count >= MAX_FISH:
    return

  var fish: Fish = fish_scene.instantiate()
  add_child(fish)

  var viewport_size: Vector2 = get_viewport().get_visible_rect().size
  fish.global_position = Vector2(
    randf_range(100, viewport_size.x - 100),
    randf_range(100, viewport_size.y - 100)
  )

  fish_count += 1
