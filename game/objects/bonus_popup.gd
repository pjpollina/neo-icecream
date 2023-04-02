extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
  $FadeOut.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  modulate.a = $FadeOut.time_left

func ping(text: String) -> void:
  $FadeOut.start(1.0)
  $Label.text = text

func _on_fade_out_timeout():
  $FadeOut.stop()
