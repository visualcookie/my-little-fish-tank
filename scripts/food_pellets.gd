extends RigidBody2D

@export var sink_rate: float = 80.0
@export var lifetime: float = 10.0

var has_hit_floor: bool = false
var decay_timer: Timer = null

func _ready() -> void:
  add_to_group("FoodPellets")
  gravity_scale = 0.0
  linear_velocity = Vector2(0, sink_rate)

  contact_monitor = true
  max_contacts_reported = 1

  body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
  Log.info("Food collided with: %s (Groups: %s)" % [body.name, str(body.get_groups())])

  if has_hit_floor:
    return

  if not (body.is_in_group("TankFloor") or body.name == "Floor"):
    return

  has_hit_floor = true
  linear_velocity = Vector2.ZERO

  Log.info("Food pellet hit the floor")

  decay_timer = Timer.new()
  add_child(decay_timer)
  decay_timer.wait_time = lifetime
  decay_timer.one_shot = true
  decay_timer.timeout.connect(_on_decay_timer_timeout)
  decay_timer.start()

func _on_decay_timer_timeout() -> void:
  Log.info("Food pellet decayed")
  queue_free()
