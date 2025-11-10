class_name FishState extends State

# Wander around, yk... nothing special fr
const WANDERING = "Wandering"
# Like sleeping but with slight movement
const CONSERVING_ENERGY = "ConservingEnergy"
# Fish is hungry and looking for food (happens only when player drops food into tank)
const SEARCHING_FOOD = "SearchingFood"

var fish: Fish

func _ready() -> void:
  await owner.ready
  fish = owner as Fish
  assert(fish != null, "The FishState state type must be used only on the fish scene. It needs the owner to be a Fish node.")
