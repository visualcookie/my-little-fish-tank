class_name Fish
extends CharacterBody2D

enum State {WANDER, HUNGRY, EATING, FLEEING}

@onready var pathing: Line2D = $Pathing

@export var speed: float = 100.0
@export var prediction_length: float = 200.0
@export var prediction_steps: int = 20

var current_state: State = State.WANDER
var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0

func _ready() -> void:
  _choose_new_wander_direction()

  if pathing != null:
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
  velocity = wander_direction * speed

  wander_timer -= delta
  if wander_timer <= 0.0:
    _choose_new_wander_direction()

  _keep_in_bounds()

func _choose_new_wander_direction() -> void:
  wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
  wander_timer = randf_range(2.0, 5.0)

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
  if velocity.x != 0:
    $Sprite.flip_h = velocity.x < 0
