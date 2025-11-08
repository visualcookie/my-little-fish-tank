class_name Fish
extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var speed: float = 100.0
var wander_radius: float = 200.0
var wander_timer: float = 0.0

func _ready() -> void:
  add_to_group("fish")

  await get_tree().physics_frame
  await get_tree().physics_frame

  _setup_navigation()

func _physics_process(delta: float) -> void:
  wander_timer -= delta
  if wander_timer <= 0.0 or nav_agent.is_navigation_finished():
    _pick_wander_target()

  if not nav_agent.is_navigation_finished():
    var next_pos: Vector2 = nav_agent.get_next_path_position()
    var dir: Vector2 = (next_pos - global_position).normalized()

    nav_agent.set_velocity(dir * speed)
  else:
    nav_agent.set_velocity(Vector2.ZERO)

func _setup_navigation() -> void:
  nav_agent.max_speed = speed
  nav_agent.avoidance_enabled = true
  nav_agent.set_velocity_forced(Vector2.ZERO)
  _pick_wander_target()

func _pick_wander_target() -> void:
  var tank_center: Vector2 = get_parent().get_viewport().get_visible_rect().size
  var random_offset: Vector2 = Vector2(
    randf_range(-wander_radius, wander_radius),
    randf_range(-wander_radius, wander_radius)
  )

  var target_position: Vector2 = tank_center + random_offset
  nav_agent.target_position = target_position
  wander_timer = randf_range(3.0, 6.0)

func _on_nav_agent_velocity_computed(suggested_velocity: Vector2) -> void:
  # Log.info("Fish %s suggested velocity: %s" % [self.name, suggested_velocity])
  velocity = suggested_velocity
  move_and_slide()

  if velocity.x != 0:
    $Sprite.flip_h = velocity.x < 0
