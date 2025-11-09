class_name Fish
extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

## Minimum speed of fish
@export var speed_min: float = 10.0
## Maximum speed of fish
@export var speed_max: float = 80.0
## Chance for fish to pause for a random amount of time
@export var pause_chance: float = 0.08

# Timer for when fish will pick a new wander target
var wander_timer: float = 0.0
# Current speed of fish
var current_speed: float = 0.0
# Whether fish is currently paused
var is_paused: bool = false
# Timer for when fish will resume movement
var pause_timer: float = 0.0

func _ready() -> void:
  add_to_group("fish")
  current_speed = randf_range(speed_min, speed_max)
  await get_tree().physics_frame
  _setup_navigation()

func _physics_process(delta: float) -> void:
  if is_paused:
    pause_timer -= delta
    if pause_timer <= 0.0:
      is_paused = false
      _pick_wander_target()
    else:
      nav_agent.set_velocity(Vector2.ZERO)
      return

  wander_timer -= delta
  if wander_timer <= 0.0 or nav_agent.is_navigation_finished():
    _pick_wander_target()

  if not nav_agent.is_navigation_finished():
    var next_pos: Vector2 = nav_agent.get_next_path_position()
    var dir: Vector2 = (next_pos - global_position).normalized()

    nav_agent.set_velocity(dir * current_speed)
  else:
    nav_agent.set_velocity(Vector2.ZERO)

func _pick_wander_target() -> void:
  if randf() < pause_chance:
    is_paused = true
    pause_timer = randf_range(1.0, 3.0)
    return

  current_speed = randf_range(speed_min, speed_max)
  nav_agent.max_speed = current_speed

  var vp_size: Vector2 = get_viewport().get_visible_rect().size
  var target_position: Vector2 = Vector2(
    randf_range(100, vp_size.x - 100),
    randf_range(100, vp_size.y - 100)
  )

  nav_agent.target_position = target_position
  wander_timer = randf_range(3.0, 6.0)

func _setup_navigation() -> void:
  nav_agent.set_velocity_forced(Vector2.ZERO)
  _pick_wander_target()

func _on_nav_agent_velocity_computed(suggested_velocity: Vector2) -> void:
  velocity = suggested_velocity
  move_and_slide()

  if velocity.x != 0:
    $Sprite.flip_h = velocity.x < 0
