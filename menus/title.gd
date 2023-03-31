extends Control

func _on_start_game_pressed():
  get_tree().change_scene_to_file("res://game/game.tscn")

func _on_instructions_pressed():
  pass

func _on_toggle_music_pressed():
  Audio.toggle_music()
  update_music_button_text()

func _on_mouse_entered_button():
  Audio.play_sfx("ui_hover")

func update_music_button_text() -> void:
  $ToggleMusic/Label.text = "Turn Music %s" % ("Off" if Audio.music_enabled else "On")
