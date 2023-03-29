## Scoop projectile class
class_name Scoop
extends Area2D

# Emitted after the scoop leaves the screen
signal outta_here

# The scoop speed (1.0 = 4px/sec)
var velocity: float

# Connect the "outta_here" signal to the scene root on init
func _ready():
  connect("outta_here", get_tree().current_scene._on_scoop_outta_here)

# Move the scoop, emit the "outta_here" signal and despawn when offscreen
func _process(delta):
  position.y -= (velocity * 240) * delta
  if global_position.y < -50:
    outta_here.emit()
    queue_free()
