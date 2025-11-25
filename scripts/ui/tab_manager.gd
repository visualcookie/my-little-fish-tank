extends Node

@onready var fish_tab: Button = get_node("../UIPanel/VBoxContainer/TabContainer/FishTab")
@onready var upgrades_tab: Button = get_node("../UIPanel/VBoxContainer/TabContainer/UpgradesTab")
@onready var decor_tab: Button = get_node("../UIPanel/VBoxContainer/TabContainer/DecorTab")
@onready var shop_tab: Button = get_node("../UIPanel/VBoxContainer/TabContainer/ShopTab")

@onready var fish_panel: Panel = get_node("../UIPanel/VBoxContainer/ContentArea/TabPanels/FishPanel")
@onready var upgrades_panel: Panel = get_node("../UIPanel/VBoxContainer/ContentArea/TabPanels/UpgradesPanel")
@onready var decor_panel: Panel = get_node("../UIPanel/VBoxContainer/ContentArea/TabPanels/DecorPanel")
@onready var shop_panel: Panel = get_node("../UIPanel/VBoxContainer/ContentArea/TabPanels/ShopPanel")

var tabs: Array[Button] = []
var panels: Array[Panel] = []

func _ready() -> void:
  # Verify all nodes exist
  assert(fish_tab != null, "FishTab button not found")
  assert(upgrades_tab != null, "UpgradesTab button not found")
  assert(decor_tab != null, "DecorTab button not found")
  assert(shop_tab != null, "ShopTab button not found")
  assert(fish_panel != null, "FishPanel not found")
  assert(upgrades_panel != null, "UpgradesPanel not found")
  assert(decor_panel != null, "DecorPanel not found")
  assert(shop_panel != null, "ShopPanel not found")

  tabs = [fish_tab, upgrades_tab, decor_tab, shop_tab]
  panels = [fish_panel, upgrades_panel, decor_panel, shop_panel]

  # Connect tab buttons
  fish_tab.toggled.connect(_on_fish_tab_toggled)
  upgrades_tab.toggled.connect(_on_upgrades_tab_toggled)
  decor_tab.toggled.connect(_on_decor_tab_toggled)
  shop_tab.toggled.connect(_on_shop_tab_toggled)

  # Set initial tab state
  fish_tab.button_pressed = true
  _switch_to_tab(0)

func _on_fish_tab_toggled(pressed: bool) -> void:
  if pressed:
    _switch_to_tab(0)

func _on_upgrades_tab_toggled(pressed: bool) -> void:
  if pressed:
    _switch_to_tab(1)

func _on_decor_tab_toggled(pressed: bool) -> void:
  if pressed:
    _switch_to_tab(2)

func _on_shop_tab_toggled(pressed: bool) -> void:
  if pressed:
    _switch_to_tab(3)

func _switch_to_tab(index: int) -> void:
  # Hide all panels and unpress all tabs
  for panel in panels:
    panel.visible = false
  for tab in tabs:
    tab.button_pressed = false

  # Show selected panel and press tab
  panels[index].visible = true
  tabs[index].button_pressed = true
