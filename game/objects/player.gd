class_name Player
extends Area2D

@export var xbounds = Vector2(0, 600-64)
@export var ybounds = Vector2(0, 600-64)

var shield_state = -1

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

func size_reset() -> void:
  scale.x = 1.0
  scale.y = 1.0

func size_macro() -> void:
  scale.x += 0.25
  scale.y += 0.25

func size_micro() -> void:
  scale.x -= 0.25
  scale.y -= 0.25

func activate_shield() -> void:
  shield_state = 1
  $Shield/A.show()
  $Shield/Timer.start(2.5)

func _on_shield_timeout():
  if shield_state == 1:
    shield_state = 0
    $Shield/A.hide()
    $Shield/B.show()
    $Shield/Timer.start(2.5)
    Audio.play_sfx("bonus_pickup")
  else:
    shield_state = -1
    $Shield/B.hide()
