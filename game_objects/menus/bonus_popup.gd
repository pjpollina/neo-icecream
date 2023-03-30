extends Control

func _process(_delta):
  $Text.modulate.a = $Timer.time_left

func ping():
  $Timer.start(1.0)
  $BellSFX.play()

func _on_timer_timeout():
  $Timer.stop()
