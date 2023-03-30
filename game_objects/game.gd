## Main game class
extends Node

var lives:  int  # The player's life count
var score:  int  # Current score
var dodges: int  # Scoops successfully dodged

# Initialize the state of the game
func _ready():
  lives = 3
  score = 0
  dodges = 0

  $StatusMenu/Lives.text = "Lives: %d" % lives
  $StatusMenu/Score.text = "Score: %d" % score
  $StatusMenu/Scoops.text = "Scoops: %d" % dodges

# Called when the player is hit by a bad projectile
func _on_player_splattered():
  $Shooter.clear_shots()
  lives -= 1
  Audio.play_sfx("splatter")

  $StatusMenu/Lives.text = "Lives: %d" % lives

  # Trigger a game over when the player is out of lives
  if(lives < 1):
    $Shooter.set_process(false)
    get_tree().change_scene_to_file("res://game_objects/game_over.tscn")

# Called after a projectile leaves the screen
func _on_scoop_outta_here(topping):
  dodges += 1
  score += 5
  if topping > Scoop.Topping.None:
    $BonusPopup.ping()
    Audio.play_sfx("bonus_topping")
    score += 10
  $StatusMenu/Score.text = "Score: %d" % score
  $StatusMenu/Scoops.text = "Scoops: %d" % dodges

func _on_load_sequence_donezo():
  $Popup.show()
  Audio.play_sfx("ui_popup_show")

func _on_popup_dismissed():
  $Popup.hide()
  Audio.play_sfx("ui_popup_hide")
  $Shooter.prepare()