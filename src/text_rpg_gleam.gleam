import hero.{Hero}
import enemy.{Enemy}
import situations
import utils.{typewrite_and_input, typewrite_page}
import gleam/string
import gleam/float
import gleam/int

const enemy_file_path = "resources/enemies.txt"
const situations_file_path = "resources/situations.txt"

pub fn main() {
  let player = hero.new()
  let enemy_list = enemy.read_batch_from(enemy_file_path)
  let situations_list = situations.read_situations(situations_file_path)
  start_round(player, enemy_list, situations_list)
}

fn start_round (
  player: Hero, 
  enemy_list: List(Enemy), 
  possible_situations: List(String)
) -> Nil {
  utils.clear_console()
  case player.health {
    health if health <=. 0.0 -> 
      typewrite_page("Your hero died. Game over!")
    health if health >=. 0.0 -> {
      let current_enemy = utils.choice(enemy_list)
      let current_situation = utils.choice(possible_situations)
      let situation_description = 
        current_situation
          |> situations.compile_situation(player, current_enemy)
      typewrite_page(situation_description)
      player
        |> start_battle(current_enemy, True)
        |> start_round(enemy_list, possible_situations)
    }
  }
}

fn start_battle(player: Hero, current_enemy: Enemy, turn: Bool) -> Hero {
  let player_dead = player.health <=. 0.0
  let enemy_dead = current_enemy.health <=. 0.0
  let enemy_name = 
        current_enemy.enemy_type
          |> utils.paint(with: "yellow")

  case turn {
    _ if player_dead -> {
      typewrite_page("Your player was defeated. ")
      player
    }
    
    _ if enemy_dead -> {
      typewrite_page("The enemy was defeated. ")
      player |> hero.select_buffs_for_hero(5)
    }

    True -> {
      let weapon = 
        "Choose your attacking weapon: "
          |> typewrite_and_input()
          |> utils.paint(with: "red")
      let damage = player |> hero.cast_damage
      let next_enemy_health = {current_enemy.health -. damage} |> float.max(0.0)
      let next_enemy = Enemy(..current_enemy, health: next_enemy_health)
      let damage_str = 
        damage
          |> utils.format_float
          |> utils.paint(with: "red")
      let enemy_health_str = 
        next_enemy_health
          |> utils.format_float
          |> utils.paint(with: "green")
      [
        "You are attacking", enemy_name, 
        "with", weapon, "causing", 
        damage_str, "damage.",
        "Now enemy has", enemy_health_str, "health."
      ]
        |> string.join(with: " ")
        |> typewrite_page
      start_battle(player, next_enemy, False)
    }

    False -> {
      let armor_block = player.luck
        |> float.round
        |> utils.random_upto
        |> int.to_float
      let actual_damage = 
        current_enemy.damage -. armor_block /. 3.0 -. player.armor
        |> float.max(0.0)
      let next_player_health = {player.health -. actual_damage} |> float.max(0.0)
      let next_player = Hero(..player, health: next_player_health)
      let damage_str = 
        actual_damage
          |> utils.format_float
          |> utils.paint(with: "red")
      let health_str = 
        next_player_health
          |> utils.format_float
          |> utils.paint(with: "green")
      [
        enemy_name, "is attacking and causing you", 
        damage_str, "damage.",
        "Now you have", health_str, "health."
      ]
        |> string.join(with: " ")
        |> typewrite_page
      start_battle(next_player, current_enemy, True)
    }
  }
}