## Scoop shooter class
extends Node2D

const Scoop = preload("res://game_objects/projectiles/scoop.tscn")

var firerate: float = 0.25  # Base time in seconds between shots
var cooldown: float = -999  # Delta timer
var last_shot: int = -1     # Most recent firing position

# Initialize the shooter
func _ready():
  pass

# Where the magic happens
func _process(delta):
  # Update the cooldown timer
  cooldown += delta

  # Where the fun begins
  if cooldown > firerate:
    cooldown = 0.0 + randf_range(-0.5, 0.0) # Slightly randomized

    # Randomly choose which position to fire from
    var pos = randi_range(0, 8)

    # Skip firing this cycle if it would repeat the previous position
    if pos == last_shot:
      last_shot = -1
      return
    else:
      last_shot = pos

    # Create the shot instance
    var shot = Scoop.instantiate()

    # Put the shot in the right spot
    shot.position = $Positions.get_point_position(pos)
    shot.translate(position)

    # Slightly randomize the velocity
    shot.velocity = randf_range(0.9, 1.1)

    # FIRE!!!
    $ShotHolder.add_child(shot)

# Called to start and/or reset the shooter
func prepare() -> void:
  firerate  = 0.25
  cooldown  = -1.5
  last_shot = -1

# Remove all shot instances from the holder
func clear_shots() -> void:
  for child in $ShotHolder.get_children():
    child.queue_free()
  prepare()

# Prevents crash when testing scene
func _on_scoop_outta_here() -> void:
  pass
