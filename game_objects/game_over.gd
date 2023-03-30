extends Control

func _on_play_again_pressed():
  get_tree().change_scene_to_file("res://game_objects/game.tscn")

func _on_return_to_title_pressed():
  get_tree().change_scene_to_file("res://game_objects/main_menu.tscn")

func _on_mouse_entered_button():
  Audio.play_sfx("ui_hover")
