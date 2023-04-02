class_name Player
extends Area2D

@export var xbounds = Vector2(0, 600-64)
@export var ybounds = Vector2(0, 600-64)

func _process(_delta):
  move()

func _ready():
  unsplat()

func move() -> void:
  position = get_global_mouse_position()
  translate(Vector2(-32, -32))
  position.x = clamp(position.x, xbounds.x, xbounds.y)
  position.y = clamp(position.y, ybounds.x, ybounds.y)

func splat(flavor: Scoop.Flavor) -> void:
  $Splatter.region_rect.position.x = (flavor * 64)
  $Splatter.show()
  $Animation.hide()

func unsplat() -> void:
  $Splatter.hide()
  $Animation.show()
  $Animation.play()
