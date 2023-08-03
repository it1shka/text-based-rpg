import hero.{Hero}
import enemy.{Enemy}
import situations
import utils.{typewrite, typewrite_and_input, typewrite_page}

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
    }
  }
}
