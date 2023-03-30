extends Node

signal donezo

@onready var points = get_parent().get_node("Positions").points
var index: int = 0

var firerate: float = 0.1  # Cooldown between loads
var cooldown: float = 0.0  # Delta timer

func _process(delta):
  # Update the cooldown timer
  cooldown += delta

  # Where the fun begins
  if cooldown > firerate:
    cooldown = 0.0

    if(index >= points.size()):
      donezo.emit()
      queue_free()
      return

    var sprite = $Sprite.duplicate()
    #sprite.texture = $Sprite.texture
    sprite.position = points[index]
    #sprite.translate(get_parent().position)
    get_parent().get_node("Scoops").add_child(sprite)
    sprite.show()

    # Play the sound
    Audio.play_sfx("loading_cone", 0.1)
    index += 1
