class_name Fish
extends Area2D

enum State {WANDER, HUNGRY, EATING, FLEEING}

@onready var pathing: Line2D = $Pathing

@export var speed: float = 100.0
@export var prediction_length: float = 200.0
@export var prediction_steps: int = 20
@export var avoidance_radius: float = 60.0
@export var avoidance_strength: float = 5.0
@export var steering_speed: float = 2.0
@export var alignment_strength: float = 0.5

var velocity: Vector2 = Vector2.ZERO
var current_state: State = State.WANDER
var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
var current_direction: Vector2 = Vector2.ZERO

var nearby_fish: Array[Fish] = []

func _ready() -> void:
  add_to_group("Fish")
  _choose_new_wander_direction()
  current_direction = wander_direction

  area_entered.connect(_on_nearby_fish_entered)
  area_exited.connect(_on_nearby_fish_exited)

  if pathing:
    pathing.visible = OS.is_debug_build()

func _physics_process(delta: float) -> void:
  match current_state:
    State.WANDER:
      _handle_wander(delta)

  _update_visuals()

  if OS.is_debug_build():
    _update_path_prediction()

  global_position += velocity * delta

func _handle_wander(delta: float) -> void:
  var avoidance := _avoid_other_fish()
  var alignment := _align_with_other_fish()

  var avoidance_magnitude := avoidance.length()
  var wander_weight: float = clamp(1.0 - avoidance_magnitude / avoidance_strength, 0.2, 1.0)
  var desired_direction := ((wander_direction * wander_weight) + avoidance + alignment).normalized()
  var steer_speed := steering_speed * (1.0 + avoidance_magnitude)
  current_direction = current_direction.lerp(desired_direction.normalized(), steer_speed * delta).normalized()

  velocity = current_direction * speed

  wander_timer -= delta
  if wander_timer <= 0.0:
    _choose_new_wander_direction()

  _keep_in_bounds()

func _choose_new_wander_direction() -> void:
  wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
  wander_timer = randf_range(2.0, 5.0)

func _avoid_other_fish() -> Vector2:
  if nearby_fish.is_empty():
    return Vector2.ZERO

  var seperation := Vector2.ZERO

  for fish in nearby_fish:
    if not is_instance_valid(fish):
      continue

    var to_fish := fish.global_position - global_position
    var distance := to_fish.length()

    if distance < avoidance_radius and distance > 1.0:
      var push_away := -to_fish.normalized()
      var strength := 1.0 - (distance / avoidance_radius)
      seperation += push_away * strength

  Log.info("Fish %s avoidance vector: %s" % [name, seperation])
  return seperation.normalized() * avoidance_strength if seperation.length() > 0.1 else Vector2.ZERO

func _align_with_other_fish() -> Vector2:
  if nearby_fish.is_empty():
    return Vector2.ZERO

  var average_direction := Vector2.ZERO

  for fish in nearby_fish:
    if not is_instance_valid(fish):
      continue

    average_direction += fish.current_direction

  return average_direction.normalized() * alignment_strength if average_direction.length() > 0.01 else Vector2.ZERO

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

func _on_nearby_fish_entered(area: Area2D) -> void:
  if area is Fish and area != self:
    nearby_fish.append(area)

func _on_nearby_fish_exited(area: Area2D) -> void:
  if area is Fish:
    nearby_fish.erase(area)
