import hero.{Hero}
import enemy.{Enemy}
import situations

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
  // TODO: ...
}
