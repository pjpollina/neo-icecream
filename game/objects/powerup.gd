## Scoop projectile class
class_name PowerUp
extends Area2D

var type: Type

func _ready():
  var roll = randi_range(1, 100)
  if   roll <  6: type = Type.ManPoints
  elif roll < 20: type = Type.FishPoints
  elif roll < 30: type = Type.ExtraLife
  elif roll < 40: type = Type.CherryPoints
  elif roll < 50: type = Type.Micro
  elif roll < 60: type = Type.Macro
  elif roll < 70: type = Type.Shield
  elif roll < 80: type = Type.Speedup
  elif roll < 90: type = Type.Slowdown
  else: type = Type.Bomb

  $Sprite.region_rect.position.x = type * 64

func _process(delta):
  position.y -= (1.0 * 240) * delta

enum Type {
  Slowdown,
  Speedup,
  Macro,
  Micro,
  Shield,
  ExtraLife,
  CherryPoints,
  FishPoints,
  ManPoints,
  Bomb,
}

static func powerup_message(type: Type) -> String:
  match type:
    Type.Slowdown:
      return "Scoop Speed Decreased!"
    Type.Speedup:
      return "Scoop Speed Increased!"
    Type.Macro:
      return "Adee Size Increased!"
    Type.Micro:
      return "Adee Size Decreased!"
    Type.Shield:
      return "Shield Activated!"
    Type.ExtraLife:
      return "Extra Life Obtained!"
    Type.CherryPoints:
      return "Cherry Bonus! +100 points!"
    Type.FishPoints:
      return "Fish Bonus! +250 points!"
    Type.ManPoints:
      return "Mystery Bonus! +1,000 points!"
    Type.Bomb:
      return "Screen cleared!"
    _:
      return "PJ messed up!"

static func powerup_sfx(type: Type) -> void:
  match type:
    Type.Bomb:
      Audio.play_sfx("bonus_clear")
    _:
      Audio.play_sfx("bonus_pickup")
