## Scoop projectile class
class_name Bullet
extends Area2D

const Flavor  = Scoop.Flavor
const Topping = Scoop.Topping

var velocity: float    # The scoop speed (1.0 = 4px/sec)
var flavor:   Flavor   # The flavor (determines sprite)
var topping:  Topping  # The topping (random bonus)

func prepare(vel: float, flavor: Flavor) -> void:
  self.velocity = vel * randf_range(0.9, 1.1)
  self.flavor = flavor
  add_topping()

# Move the scoop, emit the "outta_here" signal and despawn when offscreen
func _process(delta):
  position.y -= (velocity * 240) * delta

# Randomly add toppings
func add_topping() -> void:
  var roll = randi_range(1, 30)
  match roll:
    30: topping = Topping.Berry
    20: topping = Topping.Caramel
    10: topping = Topping.Fudge
    _:  topping = Topping.None
