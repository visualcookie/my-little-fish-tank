class_name State
extends Node

signal transitioned(next_state_path: String, data: Dictionary)

func enter(previous_state_path: String, data: Dictionary = {}) -> void:
  pass

func exit() -> void:
  pass

func update(_delta: float) -> void:
  pass

func physics_update(_delta: float) -> void:
  pass

func handle_input(_event: InputEvent) -> void:
  pass