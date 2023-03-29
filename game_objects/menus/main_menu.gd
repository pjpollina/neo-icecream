extends Control

func _on_start_game_pressed():
  get_tree().change_scene_to_file("res://game_objects/scenes/game.tscn")

func _on_instructions_pressed():
  pass

func _on_toggle_music_pressed():
  pass
