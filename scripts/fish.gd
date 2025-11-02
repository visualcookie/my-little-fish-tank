class_name Fish
extends CharacterBody2D

enum State {WANDER, HUNGRY, EATING, FLEEING}

@onready var pathing: Line2D = $Pathing

@export var speed: float = 100.0
@export var prediction_length: float = 200.0
@export var prediction_steps: int = 20
@export var avoidance_radius: float = 60.0
@export var avoidance_strength: float = 3
@export var steering_speed: float = 2.0

var current_state: State = State.WANDER
var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
var current_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
  add_to_group("Fish")
  _choose_new_wander_direction()
  current_direction = wander_direction

  if pathing:
    pathing.visible = OS.is_debug_build()

func _physics_process(delta: float) -> void:
  match current_state:
    State.WANDER:
      _handle_wander(delta)

  _update_visuals()

  if OS.is_debug_build():
    _update_path_prediction()

  move_and_slide()

func _handle_wander(delta: float) -> void:
  var avoidance_direction := _avoid_other_fish()
  var direction: Vector2

  if avoidance_direction.length() > 0.1:
    direction = avoidance_direction
  else:
    direction = wander_direction

  current_direction = current_direction.lerp(direction, steering_speed * delta).normalized()

  if current_direction.length_squared() > 0.01:
    current_direction = current_direction.normalized()

  velocity = current_direction * speed

  wander_timer -= delta
  if wander_timer <= 0.0:
    _choose_new_wander_direction()

  _keep_in_bounds()

func _choose_new_wander_direction() -> void:
  wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
  wander_timer = randf_range(2.0, 5.0)

func _avoid_other_fish() -> Vector2:
  var seperation := Vector2.ZERO
  var nearby_fish := 0

  var all_fish := get_tree().get_nodes_in_group("Fish")

  for fish in all_fish:
    if fish == self:
      continue

    var distance := global_position.distance_to(fish.global_position)

    if distance < avoidance_radius and distance > 0:
      Log.info("Avoiding fish at distance: %s" % distance)
      var push_away := global_position.direction_to(fish.global_position) * -1
      var strength := 1.0 - (distance / avoidance_radius)
      seperation += push_away * strength
      nearby_fish += 1

  if nearby_fish > 0:
    seperation = seperation / nearby_fish
    seperation = seperation.normalized() * avoidance_strength

  return seperation

func _keep_in_bounds() -> void:
  var viewport_size: Vector2 = get_viewport().get_visible_rect().size
  var margin := 100.0
  var turn_force := 2.0

  if global_position.x < margin:
    wander_direction.x += turn_force * get_physics_process_delta_time()
  elif global_position.x > viewport_size.x - margin:
    wander_direction.x -= turn_force * get_physics_process_delta_time()

  if global_position.y < margin:
    wander_direction.y += turn_force * get_physics_process_delta_time()
  elif global_position.y > viewport_size.y - margin:
    wander_direction.y -= turn_force * get_physics_process_delta_time()

  wander_direction = wander_direction.normalized()

func _update_path_prediction() -> void:
  if not OS.is_debug_build() or not pathing:
    return

  if current_state != State.WANDER:
    pathing.clear_points()
    return

  pathing.clear_points()

  var sim_pos := Vector2.ZERO
  var sim_direction := wander_direction
  var step_distance := prediction_length / prediction_steps

  for i in prediction_steps:
    pathing.add_point(sim_pos)
    sim_pos += sim_direction * step_distance
    _simulate_boundary_steering(sim_pos, sim_direction)

func _simulate_boundary_steering(sim_pos: Vector2, sim_direction: Vector2) -> void:
  var viewport_size := get_viewport_rect().size
  var margin := 100.0
  var turn_force := 0.5

  var world_pos := global_position + sim_pos

  if world_pos.x < margin:
    sim_direction.x += turn_force
  elif world_pos.x > viewport_size.x - margin:
    sim_direction.x -= turn_force

  if world_pos.y < margin:
    sim_direction.y += turn_force
  elif world_pos.y > viewport_size.y - margin:
    sim_direction.y -= turn_force

  sim_direction = sim_direction.normalized()

func _update_visuals() -> void:
  if current_direction.x != 0:
    $Sprite.flip_h = current_direction.x < 0
