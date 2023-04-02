extends Control

@onready var lives_fmt = $Lives.text
@onready var scoops_fmt = $Scoops.text
@onready var score_fmt = $Score.text

func update_lives(lives: int) -> void:
  $Lives.text = lives_fmt % lives

func update_scoops(dodges: int, quota: int) -> void:
  $Scoops.text = scoops_fmt % [dodges, quota]

func update_score(score: int) -> void:
  if score > 999:
    var k = floori(score / 1000)
    var h = score % 1000
    $Score.text = score_fmt % str("%d,%03d" % [k, h])
  else:
    $Score.text = score_fmt % str(score)
