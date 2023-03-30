## Player class
extends Area2D

# Signal for when the player is hit by a bad scoop
signal splattered

# The boundaries the player is confined to
@export var xbounds: Vector2 = Vector2(0, 600 - 64)
@export var ybounds: Vector2 = Vector2(0, 600 - 64)

# Move the player to the mouse, within bounds
func _process(_delta):
  position = get_global_mouse_position()
  translate(Vector2(-32, -32))
  position.x = clamp(position.x, xbounds.x, xbounds.y)
  position.y = clamp(position.y, ybounds.x, ybounds.y)

# Called when player is hit
func _on_area_entered(area):
  if area as Scoop:
    $SplatterSFX.play()
    splattered.emit()
