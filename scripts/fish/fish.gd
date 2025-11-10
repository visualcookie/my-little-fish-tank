class_name Fish
extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

## Minimum speed of fish
@export var speed_min: float = 10.0
## Maximum speed of fish
@export var speed_max: float = 80.0

# Timer for when fish will pick a new wander target
var wander_timer: float = 0.0
# Current speed of fish
var current_speed: float = 0.0
# Current fish energy
var current_energy: float = 100.0
# Timer for how long fish will conserve energy
var conserving_energy_timer: float = 0.0

func _ready() -> void:
  add_to_group("fish")
  current_speed = randf_range(speed_min, speed_max)
  current_energy = randf_range(50, 100)

  await get_tree().physics_frame
  await get_tree().physics_frame

  nav_agent.set_velocity_forced(Vector2.ZERO)

func _on_nav_agent_velocity_computed(suggested_velocity: Vector2) -> void:
  velocity = suggested_velocity
  move_and_slide()

  if velocity.x != 0:
    $Sprite.flip_h = velocity.x < 0
