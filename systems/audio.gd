extends Node

var music: AudioStreamPlayer
var music_enabled: bool = true

var sfx
var sfx_enabled: bool = true

func _ready():
  music = $Music
  music.play()

  sfx = {
    "bonus_topping": $SFX/BonusTopping,
    "bonus_pickup":  $SFX/BonusPickup,
    "bonus_clear":   $SFX/BonusClear,
    "loading_cone":  $SFX/LoadingCone,
    "splatter":      $SFX/Splatter,
    "ui_hover":      $SFX/UIHover,
    "ui_popup_show": $SFX/UIPopupShow,
    "ui_popup_hide": $SFX/UIPopupHide,
  }

func _on_music_finished():
  if music_enabled:
    music.play()

func toggle_music() -> void:
  music_enabled = !music_enabled
  if music.playing and !music_enabled:
    music.stop()
  if !music.playing and music_enabled:
    music.play()

func toggle_sfx() -> void:
  sfx_enabled = !sfx_enabled

func play_sfx(name: String, pos=0.0) -> void:
  if sfx_enabled:
    sfx[name].play(pos)
