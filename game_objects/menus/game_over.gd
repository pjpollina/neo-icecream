extends Control

func _on_play_again_pressed():
  get_tree().change_scene_to_file("res://game_objects/scenes/game.tscn")

func _on_return_to_title_pressed():
  get_tree().change_scene_to_file("res://game_objects/menus/main_menu.tscn")
