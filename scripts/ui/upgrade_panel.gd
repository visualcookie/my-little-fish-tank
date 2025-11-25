extends Node

@onready var better_filter_button: Button = get_node("../UIPanel/ContentArea/TabContainer/UPGRADES/ScrollContainer/UpgradesGrid/BetterFilter/BuyButton")
@onready var warm_heater_button: Button = get_node("../UIPanel/ContentArea/TabContainer/UPGRADES/ScrollContainer/UpgradesGrid/WarmHeater/BuyButton")
@onready var cozy_light_button: Button = get_node("../UIPanel/ContentArea/TabContainer/UPGRADES/ScrollContainer/UpgradesGrid/CozyLight/BuyButton")
@onready var auto_feeder_button: Button = get_node("../UIPanel/ContentArea/TabContainer/UPGRADES/ScrollContainer/UpgradesGrid/AutoFeeder/BuyButton")

const BETTER_FILTER_COST: int = 100
const WARM_HEATER_COST: int = 65
const COZY_LIGHT_COST: int = 20
const AUTO_FEEDER_COST: int = 20

func _ready() -> void:
  assert(better_filter_button != null, "BetterFilter button not found")
  assert(warm_heater_button != null, "WarmHeater button not found")
  assert(cozy_light_button != null, "CozyLight button not found")
  assert(auto_feeder_button != null, "AutoFeeder button not found")

  better_filter_button.pressed.connect(_on_better_filter_pressed)
  warm_heater_button.pressed.connect(_on_warm_heater_pressed)
  cozy_light_button.pressed.connect(_on_cozy_light_pressed)
  auto_feeder_button.pressed.connect(_on_auto_feeder_pressed)

func _on_better_filter_pressed() -> void:
  if GameState.subtract_gold(BETTER_FILTER_COST):
    Log.info("Better Filter purchased for %s gold" % BETTER_FILTER_COST)
  else:
    Log.info("Not enough gold for Better Filter")

func _on_warm_heater_pressed() -> void:
  if GameState.subtract_gold(WARM_HEATER_COST):
    Log.info("Warm Heater purchased for %s gold" % WARM_HEATER_COST)
  else:
    Log.info("Not enough gold for Warm Heater")

func _on_cozy_light_pressed() -> void:
  if GameState.subtract_gold(COZY_LIGHT_COST):
    Log.info("Cozy Light purchased for %s gold" % COZY_LIGHT_COST)
  else:
    Log.info("Not enough gold for Cozy Light")

func _on_auto_feeder_pressed() -> void:
  if GameState.subtract_gold(AUTO_FEEDER_COST):
    Log.info("Auto-Feeder purchased for %s gold" % AUTO_FEEDER_COST)
  else:
    Log.info("Not enough gold for Auto-Feeder")
