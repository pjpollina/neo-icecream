## Scoop projectile class
class_name Scoop
extends Area2D

# Emitted after the scoop leaves the screen
signal outta_here(topping)

var velocity: float    # The scoop speed (1.0 = 4px/sec)
var flavor:   Flavor   # The flavor (determines sprite)
var topping:  Topping  # The topping (random bonus)

func prepare(vel: float, flavor: Flavor) -> void:
  self.velocity = vel * randf_range(0.9, 1.1)
  self.flavor = flavor
  if randi_range(1, 10) == 1:
    self.topping = randi_range(Topping.A, Topping.C) as Topping
  else:
    self.topping = Topping.None

# Connect the "outta_here" signal to the scene root on init
func _ready():
  connect("outta_here", get_tree().current_scene._on_scoop_outta_here)
  set_flavor_sprite()
  set_topping_sprite()

# Move the scoop, emit the "outta_here" signal and despawn when offscreen
func _process(delta):
  position.y -= (velocity * 240) * delta
  if global_position.y < -50:
    outta_here.emit(topping)
    queue_free()

func set_flavor_sprite():
  $Sprite.region_rect.position.x = (64 * flavor as int)

func set_topping_sprite():
  $Topping.region_rect.position.x = (64 * topping as int)

enum Flavor {
  Strawberry,
  Vanilla,
  Chocolate,

  RaspRipple,
  Butterscotch,
  FudgeRipple,

  Swirl,
  Neapolitan,
  Hydrox,

  MintChip,
  RockyRoad,
  Ube,
}

# TODO: Name toppings once they have finalized assets
enum Topping {
  None, A, B, C,
}
