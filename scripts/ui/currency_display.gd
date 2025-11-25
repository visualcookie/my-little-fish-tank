extends Node

@onready var gold_label: Label = get_node("../UIPanel/ContentArea/CurrencyPanel/VBoxContainer/GoldLabel")

func _ready() -> void:
  assert(gold_label != null, "GoldLabel not found")
  GameState.gold_changed.connect(_on_gold_changed)
  _update_display()

func _on_gold_changed(new_amount: int) -> void:
  _update_display()

func _update_display() -> void:
  gold_label.text = "Gold: %s" % GameState.gold
