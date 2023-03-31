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

func _process(delta):
  $Player.position = $Player.get_global_mouse_position()
  $Player.translate(Vector2(-32, -32))
  $Player.position.x = clamp($Player.position.x, 0, 600-64)
  $Player.position.y = clamp($Player.position.y, 0, 600-64)
  $BonusPopup/Text.modulate.a = $BonusPopup/Timer.time_left

  if loading: process_loader(delta)
  else: process_shooter(delta)

# Called when player is hit
func _on_player_area_entered(area):
  if area as Scoop:
    clear_shots()
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
    $BonusPopup/Timer.start(1.0)
    Audio.play_sfx("bonus_topping")
    score += 10
  $StatusMenu/Score.text = "Score: %d" % score
  $StatusMenu/Scoops.text = "Scoops: %d" % dodges

func _on_timer_timeout():
  $BonusPopup/Timer.stop()

func _on_level_popup_gui_input(event):
  if event as InputEventMouseButton:
    $LevelPopup.hide()
    Audio.play_sfx("ui_popup_hide")
    prepare()

const scoop = preload("res://game_objects/scoop.tscn")

var firerate: float = 0.25  # Base time in seconds between shots
var cooldown: float = -999  # Delta timer
var last_shot: int = -1     # Most recent firing position

# Where the magic happens
func process_shooter(delta):
  # Update the cooldown timer
  cooldown += delta

  # Where the fun begins
  if cooldown > firerate:
    cooldown = 0.0 + randf_range(-0.5, 0.0) # Slightly randomized

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
    $Shooter/ShotHolder.add_child(shot)

# Called to start and/or reset the shooter
func prepare() -> void:
  firerate  = 0.25
  cooldown  = -1.5
  last_shot = -1

# Remove all shot instances from the holder
func clear_shots() -> void:
  for child in $Shooter/ShotHolder.get_children():
    child.queue_free()
  prepare()

var index: int = 0
var loading: bool = true

var load_firerate: float = 0.1  # Cooldown between loads
var load_cooldown: float = 0.0  # Delta timer

func process_loader(delta):
  # Update the cooldown timer
  load_cooldown += delta

  # Where the fun begins
  if load_cooldown > load_firerate:
    load_cooldown = 0.0

    if(index >= $Shooter/Positions.points.size()):
      loading = false
      $LevelPopup.show()
      Audio.play_sfx("ui_popup_show")
      return

    var sprite = $Shooter/LoadSequence/Sprite.duplicate()
    #sprite.texture = $Sprite.texture
    sprite.position = $Shooter/Positions.points[index]
    #sprite.translate(get_parent().position)
    $Shooter/Scoops.add_child(sprite)
    sprite.show()

    # Play the sound
    Audio.play_sfx("loading_cone", 0.1)
    index += 1
