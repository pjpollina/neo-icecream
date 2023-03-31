## Main game class
extends Node

const scoop = preload("res://game/objects/scoop.tscn")

## GAME STATE ########################################
##
var lives:  int  # The player's life count
var score:  int  # Current score
var dodges: int  # Scoops successfully dodged
##
## SHOOTER STATE #####################################
##
var loading:   int   # State of loader (8 = Done)
var last_shot: int   # Most recent firing position
var shooting:  bool  # Is shooter shooting?

# Initialize the state of the game
func _ready():
  lives = 3
  score = 0
  dodges = 0

  shooting = false
  loading = 0
  last_shot = -1

  update_status_menu()

func _process(_delta):
  move_player()
  update_bonus_fade()

# Called after a projectile leaves the screen
func _on_scoop_outta_here(topping):
  dodges += 1
  score += 5
  if topping > Scoop.Topping.None:
    show_bonus_popup()
    score += 10
  update_status_menu()

# Remove all shot instances from the holder
func clear_shots() -> void:
  for child in $Scoops.get_children():
    child.queue_free()
  shooting = false
  $Shooter/ClearCooldown.start()

## PLAYER ############################################
##

func move_player():
  $Player.position = $Player.get_global_mouse_position()
  $Player.translate(Vector2(-32, -32))
  $Player.position.x = clamp($Player.position.x, 0, 600-64)
  $Player.position.y = clamp($Player.position.y, 0, 600-64)

# Called when player is hit
func _on_player_area_entered(area):
  if area as Scoop:
    clear_shots()
    lives -= 1
    Audio.play_sfx("splatter")
    update_status_menu()

## SHOOTER ###########################################
##

func _on_shot_cooldown_timeout():
  if !shooting: return

  # Slightly randomize cooldown for next shot
  $Shooter/ShotCooldown.wait_time = 0.25 + randf_range(-0.1, 0.5)

  # Randomly choose which position to fire from
  var pos = randi_range(0, 8)

  # Skip firing this cycle if it would repeat the previous position
  if pos == last_shot:
    last_shot = -1
    return
  else:
    last_shot = pos

  # Create the shot instance
  var shot = scoop.instantiate()
  shot.prepare(1.0, Scoop.Flavor.Strawberry)

  # Put the shot in the right spot
  shot.position = $Shooter/Positions.get_point_position(pos)
  shot.translate($Shooter.position)

  # FIRE!!!
  $Scoops.add_child(shot)

func _on_clear_cooldown_timeout():
  # Trigger a game over when the player is out of lives
  if(lives < 1):
    Audio.play_sfx("ui_popup_show")
    get_tree().change_scene_to_file("res://menus/game_over.tscn")

  # Otherwise, resume
  shooting = true
  $Shooter/ClearCooldown.stop()

## LOADER ############################################
##

func _on_load_delay_timeout():
  # Remove the timer once loading is done
  if(loading >= $Shooter/Positions.points.size()):
    $Shooter/LoadDelay.queue_free()
    show_level_popup()
    return

  # Load up the image
  var sprite = $Shooter/Scoops/Base.duplicate()
  sprite.position = $Shooter/Positions.points[loading]
  $Shooter/Scoops.add_child(sprite)
  sprite.show()

  # Play the sound
  Audio.play_sfx("loading_cone", 0.1)

  # Increment
  loading += 1

## STATUS MENU #######################################
##

func update_status_menu():
  $StatusMenu/Lives.text = "Lives: %d" % lives
  $StatusMenu/Score.text = "Score: %d" % score
  $StatusMenu/Scoops.text = "Scoops: %d" % dodges

## BONUS POPUP #######################################
##

func show_bonus_popup():
  $BonusPopup/FadeTimer.start(1.0)
  Audio.play_sfx("bonus_topping")

func update_bonus_fade():
  $BonusPopup/Text.modulate.a = $BonusPopup/FadeTimer.time_left

func _on_bonus_fade_timer_timeout():
  $BonusPopup/FadeTimer.stop()

## LEVEL POPUP #######################################
##

func show_level_popup():
  $LevelPopup.show()
  Audio.play_sfx("ui_popup_show")

func _on_level_popup_gui_input(event):
  if event as InputEventMouseButton:
    $LevelPopup.hide()
    Audio.play_sfx("ui_popup_hide")
    shooting = true
