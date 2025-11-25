extends Node

signal gold_changed(new_amount: int)

var gold: int = 450:
  set(value):
    gold = value
    gold_changed.emit(gold)

func add_gold(amount: int) -> void:
  gold += amount

func subtract_gold(amount: int) -> bool:
  if gold >= amount:
    gold -= amount
    return true
  return false

