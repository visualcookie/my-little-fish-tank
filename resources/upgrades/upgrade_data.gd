class_name UpgradeData
extends Resource

@export var upgrade_id: String
@export var display_name: String
@export var description: String
@export var cost: int
@export var icon: Texture2D
@export var effect_script: GDScript

func _init() -> void:
  assert(upgrade_id.is_empty() == false, "Upgrade ID is empty")
  assert(display_name.is_empty() == false, "Display name is empty")
  assert(description.is_empty() == false, "Description is empty")
  assert(cost >= 0, "Cost is less than 0")
  assert(icon != null, "Icon is null")
  assert(effect_script != null, "Effect script is null")
  assert(effect_script.has_method("apply") == true, "Effect script has no apply method")
