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

# Called when the player is hit by a bad projectile
func _on_player_splattered():
  $Shooter.clear_shots()
  lives -= 1

  # Trigger a game over when the player is out of lives
  if(lives < 1):
    $Shooter.set_process(false)
    $GameOver.show()

# Called after a projectile leaves the screen
func _on_scoop_outta_here():
  dodges += 1
  score += 5

# Restart the game after a game-over
func _on_replay_pressed():
  get_tree().reload_current_scene()

# Quit the game
func _on_quit_pressed():
  get_tree().quit()
