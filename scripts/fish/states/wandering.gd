extends FishState

func enter(previous_state_path: String, data := {}) -> void:
  _new_wander_location()

func physics_update(_delta: float) -> void:
  fish.wander_timer -= _delta

  # Consume energy when moving, gain energy when not moving
  fish.current_energy -= _delta * 0.1 if fish.velocity.length() > 10 else 0.05
  fish.current_energy = clamp(fish.current_energy, 0, 100)
  Log.info("Fish energy: %s" % fish.current_energy)

  if fish.current_energy < 10:
    transitioned.emit(CONSERVING_ENERGY)
    return

  if fish.wander_timer <= 0.0 or fish.nav_agent.is_navigation_finished():
    _new_wander_location()

  if not fish.nav_agent.is_navigation_finished():
    var next_pos = fish.nav_agent.get_next_path_position()
    var dir = (next_pos - fish.global_position).normalized()
    fish.nav_agent.set_velocity(dir * fish.current_speed)

func _new_wander_location() -> void:
  var vp_size: Vector2 = get_viewport().get_visible_rect().size
  var target_position: Vector2 = Vector2(
    randf_range(100, vp_size.x - 100),
    randf_range(100, vp_size.y - 100)
  )

  fish.nav_agent.target_position = target_position
  fish.wander_timer = randf_range(3.0, 6.0)
  fish.current_speed = randf_range(fish.speed_min, fish.speed_max)
