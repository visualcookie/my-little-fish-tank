extends FishState

func enter(previous_state_path: String, data := {}) -> void:
  fish.conserving_energy_timer = randf_range(3.0, 6.0)

func physics_update(_delta: float) -> void:
  fish.conserving_energy_timer -= _delta

  if fish.conserving_energy_timer <= 0.0:
    transitioned.emit(WANDERING)
    return

  fish.current_energy += _delta * 15.0
  fish.current_energy = clamp(fish.current_energy, 0, 100)

  var time = Time.get_ticks_msec() * 0.001
  var gentle_drift = Vector2(
    sin(time) * 8.0,
    cos(time * 0.8) * 5.0
  )

  fish.nav_agent.set_velocity(gentle_drift)

  Log.info("Fish energy: %s" % fish.current_energy)