extends Control

@onready var level_text = $Contents/Level.text
@onready var flavor_text = $Contents/Flavor.text
@onready var quota_text = $Contents/Quota.text

func prep(level: Scoop.Flavor) -> void:
  $Foreground.texture = load("res://assets/gui/splash_level_%02d.webp" % (level + 1))
  $Contents/Level.text = level_text % (level + 1)
  $Contents/Flavor.text = flavor_text % Scoop.flavor_name(level)
  $Contents/Quota.text = quota_text % (25 + (level * 25))
