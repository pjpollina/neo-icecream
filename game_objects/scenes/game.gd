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
    get_tree().change_scene_to_file("res://game_objects/menus/game_over.tscn")

# Called after a projectile leaves the screen
func _on_scoop_outta_here():
  dodges += 1
  score += 5
