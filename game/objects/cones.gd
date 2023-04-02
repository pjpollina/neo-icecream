extends Node2D

signal done_loading

var loaded: int = 0
@onready var scoops = $Scoops.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
  for scoop in scoops: scoop.hide()

# Changes the displayed flavor
func set_scoops_flavor(flavor: Scoop.Flavor):
  for scoop in scoops: scoop.flavor = flavor

# Called every load tick
func _on_load_proc():
  Audio.play_sfx("loading_cone", 0.1)
  scoops[loaded].show()
  loaded += 1

  if loaded >= scoops.size():
    $LoadDelay.queue_free()
    done_loading.emit()
