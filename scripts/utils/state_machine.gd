class_name StateMachine
extends Node

@export var initial_state: State = null

@onready var state: State = (func get_initial_state() -> State:
  return initial_state if initial_state != null else get_child(0)
).call()

func _ready() -> void:
  for state_node: State in find_children("*", "State"):
    state_node.transitioned.connect(_transition_to_next_state)

  await owner.ready
  state.enter("")

func _unhandled_input(event: InputEvent) -> void:
  state.handle_input(event)

func _process(delta: float) -> void:
  state.update(delta)

func _physics_process(delta: float) -> void:
  state.physics_update(delta)

func _transition_to_next_state(next_state_path: String, data: Dictionary = {}) -> void:
  if not has_node(next_state_path):
    Log.error("%s: Trying to transition to state %s but it does not exist." % [owner.name, next_state_path])
    return

  var previous_state_path := state.name
  state.exit()
  state = get_node(next_state_path)
  state.enter(previous_state_path, data)
