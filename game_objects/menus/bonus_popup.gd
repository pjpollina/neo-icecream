extends Control

func _process(_delta):
  $Text.modulate.a = $Timer.time_left

func ping():
  $Timer.start(1.0)
  Audio.play_sfx("bonus_topping")

func _on_timer_timeout():
  $Timer.stop()
