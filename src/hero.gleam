import utils
import gleam/string

pub type Hero {
  Hero (
    name: String,
    health: Float,
    armor: Float,
    damage: Float
  )
}

pub fn new() -> Hero {
  let name = utils.read_string("Hero name: ")
  let health = utils.read_float("Hero health: ")
  let armor = utils.read_float("Hero armor: ")
  let damage = utils.read_float("Hero damage: ")
  Hero(name, health, armor, damage)
}

pub fn to_string(hero: Hero) -> String {
  let name = 
    hero.name 
      |> utils.paint(with: "yellow")
  let health = 
    hero.health 
      |> utils.format_float
      |> utils.paint(with: "green")
  let armor = 
    hero.armor
      |> utils.format_float
      |> utils.paint(with: "blue")
  let damage = 
    hero.damage
      |> utils.format_float
      |> utils.paint(with: "red")
  string.join([ 
    "Hero", name, 
    "with health", health,
    "and armor", armor,
    "causing damage", damage
  ], with: " ") 
}