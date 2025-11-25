extends Control

@export var fish_manager: Node
@export var food_spawner: Node

@onready var buy_fish_button: Button = $BuyFishButton

func _ready() -> void:
  buy_fish_button.pressed.connect(_on_buy_fish_pressed)

  assert(fish_manager != null, "FishManager node is not assigned in UI.gd")
  assert(food_spawner != null, "FoodSpawner node is not assigned in UI.gd")

func _on_buy_fish_pressed() -> void:
  if fish_manager:
    fish_manager.spawn_fish()
    Log.info("Buy Fish button pressed")
