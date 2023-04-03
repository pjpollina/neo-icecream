extends Control

func _ready():
  Audio.play_sfx("ui_popup_show")

func _on_play_again_pressed():
  Audio.play_sfx("ui_popup_hide")
  get_tree().change_scene_to_file("res://game/game.tscn")

func _on_return_to_title_pressed():
  Audio.play_sfx("ui_popup_hide")
  get_tree().change_scene_to_file("res://menus/title.tscn")

func _on_mouse_entered_button():
  Audio.play_sfx("ui_hover")
