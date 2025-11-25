extends Node

signal upgrade_purchased(upgrade_id: String, upgrade_data: UpgradeData)

var purchased_upgrades: Dictionary = {}

func _ready() -> void:
  pass

func purchase_upgrade(upgrade_data: UpgradeData) -> bool:
  if upgrade_data == null:
    Log.error("Upgrade data is null")
    return false

  if upgrade_data.upgrade_id.is_empty():
    Log.error("Upgrade ID is empty")
    return false

  if purchased_upgrades.has(upgrade_data.upgrade_id):
    Log.info("Upgrade %s already purchased" % upgrade_data.upgrade_id)
    return false

  if not GameState.subtract_gold(upgrade_data.cost):
    Log.info("Not enough gold to purchase upgrade")
    return false

  purchased_upgrades[upgrade_data.upgrade_id] = upgrade_data
  _apply_upgrade_effect(upgrade_data)

  upgrade_purchased.emit(upgrade_data.upgrade_id, upgrade_data)
  Log.info("Upgrade %s purchased for %s gold" % [upgrade_data.upgrade_id, upgrade_data.cost])

  return true

func _apply_upgrade_effect(upgrade_data: UpgradeData) -> void:
  if upgrade_data.effect_script == null:
    Log.warning("Upgrade %s has no effect script" % upgrade_data.display_name)
    return

  if upgrade_data.effect_script.has_method("apply"):
    upgrade_data.effect_script.apply(upgrade_data)
  else:
    Log.error("Upgrade %s effect script has no apply method" % upgrade_data.display_name)
    return

func is_upgrade_purchasable(upgrade_id: String) -> bool:
  return purchased_upgrades.has(upgrade_id)

func get_purchased_upgrade(upgrade_id: String) -> UpgradeData:
  return purchased_upgrades.get(upgrade_id, null)
