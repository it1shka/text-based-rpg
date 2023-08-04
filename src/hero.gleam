import utils
import gleam/string
import gleam/io
import gleam/int
import gleam/float

pub type Hero {
  Hero (
    name: String,
    health: Float,
    armor: Float,
    damage: Float,
    luck: Float
  )
}

pub fn new() -> Hero {
  utils.clear_console()
  let name = utils.read_string("Hero name: ")
  let brand_new_hero = Hero (
    name,
    health: 10.0,
    armor: 2.0,
    damage: 2.0,
    luck: 1.0
  )
  let buffed_hero = 
    brand_new_hero 
      |> select_buffs_for_hero(5)
  utils.clear_console()
  buffed_hero
}

pub fn select_buffs_for_hero(hero: Hero, points: Int) -> Hero {
  case points {
    0 -> hero
    _ -> {
      utils.clear_console()
      let Hero(name, health, armor, damage, luck) = hero
      io.println(hero |> to_string)
      io.print("Available buffs: ")
      points 
        |> int.to_string
        |> utils.paint(with: "cyan")
        |> io.println
      case select_buff() {
        Health -> Hero(name, health +. 1.0, armor, damage, luck)
        Armor  -> Hero(name, health, armor +. 1.0, damage, luck)
        Damage -> Hero(name, health, armor, damage +. 1.0, luck)
        Luck   -> Hero(name, health, armor, damage, luck +. 1.0)
      } |> select_buffs_for_hero(points - 1)
    }
  }
}

type Buff {
  Health
  Armor
  Damage
  Luck
}

const select_buff_message = "
  Please, select among these buffs:
  1) Health
  2) Armor
  3) Damage
  4) Luck
"
const select_buff_warning = "You should choose between 1-4. "
fn select_buff() -> Buff {
  let user_input = 
    select_buff_message
      |> utils.dedent
      |> string.append("\n")
      |> utils.read_integer
  case user_input {
    1 -> Health
    2 -> Armor
    3 -> Damage
    4 -> Luck
    _ -> {
      io.println(select_buff_warning)
      select_buff()
    } 
  }
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
  let luck = 
    hero.luck
      |> utils.format_float
      |> utils.paint(with: "purple")
  string.join([ 
    "Hero", name, 
    "with health", health,
    "and armor", armor,
    "causing damage", damage,
    "being lucky by", luck
  ], with: " ") 
}

pub fn cast_damage(hero: Hero) -> Float {
  let Hero(damage: damage, luck: luck, ..) = hero
  let lucky_damage = 
    luck
      |> float.round
      |> utils.random_upto
      |> int.to_float
  damage +. lucky_damage /. 3.0
}