class_name Scoop
extends Sprite2D

@export var flavor: Flavor:
  set(new):
    flavor = new as Flavor
    region_rect.position.x = 64 * new

@export var topping: Topping:
  set(new):
    topping = new
    $Topping.region_rect.position.x = 64 * new

enum Flavor {
  Strawberry,
  Vanilla,
  Chocolate,
  RaspberryRipple,
  Butterscotch,
  FudgeRipple,
  Swirl,
  Neapolitan,
  Hydrox,
  MintChip,
  RockyRoad,
  Ube,
}

static func flavor_name(flavor: Flavor) -> String:
  match(flavor):
    Flavor.RaspberryRipple:
      return "Raspberry Ripple"
    Flavor.FudgeRipple:
      return "Fudge Ripple"
    Flavor.MintChip:
      return "Mint Chocolate Chip"
    Flavor.RockyRoad:
      return "Rocky Road"
    _:
      return Flavor.keys()[flavor]

enum Topping {
  None,
  Caramel,
  Fudge,
  Berry,
}
