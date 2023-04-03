extends Node

const _Bullet  = preload("res://game/objects/bullet.tscn")
const _PowerUp = preload("res://game/objects/powerup.tscn")

@onready var player = $Player

## Player state
var lives: int = 3
var score: int = 0
var level: Scoop.Flavor = Scoop.Flavor.Strawberry

## Reset on new level
var dodges: int = 0

## Reset on screen clear
var last_firing_pos: int = -1
var powerup_speed_offset: float = 0.0

## ###################################################
## Shot Info ##
##

# Gets the amount of shots currently active
func active_shots() -> int:
  return get_tree().get_nodes_in_group("projectiles").size()

# Checks if there are enough shots to clear the level active
func enough_shots() -> bool:
  return level_scoop_count() <= (dodges + get_tree().get_nodes_in_group("projectiles").size())

# Clear the screen of shots and cooldown
func clear_shots() -> void:
  get_tree().call_group("projectiles", "queue_free")
  $ClearCooldown.start()

# Checks if the level is clear of shots
func check_level_clear() -> bool:
  return enough_shots() && active_shots() < 1

# Signal processor for shots hitting the despawn plane
func _on_despawn_point_area_entered(area):
  dodges += 1
  score += 5
  if area as Bullet:
    if area.topping != Scoop.Topping.None:
      score += 10
      $BonusPopup.ping("Topping Bonus!")
      Audio.play_sfx("bonus_topping")
  area.queue_free()

## ###################################################
## Shot Maker
##

# Gets the base speed of scoops for this level
func level_scoop_speed() -> float:
  return 1.0 + (level / 10.0)

# Gets the amount of scoops for this level
func level_scoop_count() -> int:
  return 25 + (level * 25)

# Generates a (semi) random position for a shot to spawn at
func random_shot_spawnpoint() -> Vector2:
  var roll = randi_range(0, 8)
  while(roll == last_firing_pos):
    roll = randi_range(0, 8)
  last_firing_pos = roll

  var point = Vector2.ZERO
  point.x = 12 + (roll * 64)
  point.y = $Cones.position.y
  return point

# Signal processor for Shooter
func _on_shooter_timeout():
  if !$ClearCooldown.is_stopped() || enough_shots(): return
  if randi_range(1, 30) == 25:
    _make_powerup_shot()
  else:
    _make_bullet_shot()
  if level > Scoop.Flavor.Chocolate: _make_bullet_shot()

# Construct and add a Bullet projectile
func _make_bullet_shot() -> void:
  var bullet = _Bullet.instantiate()
  bullet.add_to_group("projectiles")
  bullet.prepare(level_scoop_speed() + powerup_speed_offset, level)
  bullet.position = random_shot_spawnpoint()
  add_child(bullet)

# Construct and add a PowerUp projectile
func _make_powerup_shot() -> void:
  var bullet = _PowerUp.instantiate()
  bullet.position = random_shot_spawnpoint()
  bullet.add_to_group("projectiles")
  add_child(bullet)

## ###################################################
## Game Flow Control ##
##

# Updates the HUD element
func update_hud() -> void:
  $Hud.update_lives(lives)
  $Hud.update_score(score)
  $Hud.update_scoops(dodges, level_scoop_count())

# Loads the next level, or sends you to the win screen if on the final level
func load_level() -> void:
  if(level == Scoop.Flavor.Ube):
    game_won()
  else:
    level += 1
    prep_level()

# Prepares the next level
func prep_level() -> void:
  Audio.play_sfx("ui_popup_show")
  dodges = 0
  reset_player()
  $LevelPopup.prep(level)
  $LevelPopup.show()
  $Cones.set_scoops_flavor(level)

# Called after the level popup is dismissed to begin firing
func start_level() -> void:
  Audio.play_sfx("ui_popup_hide")
  $LevelPopup.hide()
  $Shooter.start(0.375 + (randf_range(-0.1, 0.1)))

# Sends you to the Game Over screen
func game_over() -> void:
  get_tree().change_scene_to_file("res://menus/game_over.tscn")

# Sends you to the You Win screen
func game_won() -> void:
  var win = load("res://menus/game_over.tscn").instantiate()
  win.get_node("Text").text = "You Win!"
  var pk = PackedScene.new()
  pk.pack(win)
  get_tree().change_scene_to_packed(pk)

# Signal processor for clear cooldown (The pause after a screen clear)
func _on_clear_cooldown_timeout():
  if lives > 0: player_recover()
  else: game_over()

# Signal processor for cones done loading (The intro animation)
func _on_cones_done_loading():
  prep_level()

# Signal processor for level delay (Slight pause between level end & new level)
func _on_level_delay_timeout():
  load_level()

# Signal processor for dismissing the level popup
func _on_level_popup_gui_input(event):
  if event as InputEventMouseButton:
    start_level()

## ###################################################
## Player Actions ##
##

# Called when the player is hit by a bad scoop
func player_take_hit() -> void:
  player.splat(level)
  reset_player()
  clear_shots()
  lives -= 1
  Audio.play_sfx("splatter")

# Called when the player is hit by a good scoop
func player_get_powerup(type: PowerUp.Type) -> void:
  match type:
    PowerUp.Type.Slowdown:      powerup_speed_offset -= 0.25
    PowerUp.Type.Speedup:       powerup_speed_offset += 0.25
    PowerUp.Type.Macro:         $Player.size_macro()
    PowerUp.Type.Micro:         $Player.size_micro()
    PowerUp.Type.Shield:        $Player.activate_shield()
    PowerUp.Type.ExtraLife:     lives += 1
    PowerUp.Type.CherryPoints:  score += 100
    PowerUp.Type.FishPoints:    score += 250
    PowerUp.Type.ManPoints:     score += 1000
    PowerUp.Type.Bomb:          clear_shots()
  PowerUp.powerup_sfx(type)
  $BonusPopup.ping(PowerUp.powerup_message(type))

# Reset transient player values
func reset_player() -> void:
  player.size_reset()
  powerup_speed_offset = 0
  player.shield_state = -1

# Called after a clear if lives > 0
func player_recover() -> void:
  player.unsplat()

# Signal processor for player collision
func _on_player_area_entered(area):
  if area as Bullet:
    if $Player.shield_state > -1:
      return
    else:
      player_take_hit()
  elif area as PowerUp:
    player_get_powerup(area.type)
  area.queue_free()

## ###################################################
## Game Control
##

func _process(_delta):
  update_hud()
  if check_level_clear() && $LevelDelay.is_stopped():
    $Shooter.stop()
    $LevelDelay.start()
