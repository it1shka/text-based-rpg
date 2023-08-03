import utils
import gleam/string
import gleam/list
import gleam/map
import gleam/float

pub type Enemy {
  Enemy (
    enemy_type: String,
    health: Float,
    damage: Float
  )
}

pub fn to_string(enemy: Enemy) -> String {
  let enemy_type = 
    enemy.enemy_type
      |> utils.paint(with: "yellow")
  let health = 
    enemy.health
      |> utils.format_float
      |> utils.paint(with: "green")
  let damage = 
    enemy.damage
      |> utils.format_float
      |> utils.paint(with: "red")
  string.join([
    "Enemy", enemy_type,
    "having", health, "of health",
    "making", damage, "of damage"
  ], with: " ")
}

pub fn read_batch_from(filepath: String) -> List(Enemy) {
  utils.read_file(filepath)
    |> string.split(on: "%%")
    |> list.map(string.trim)
    |> list.filter(fn (elem) { !string.is_empty(elem) })
    |> list.map(fn (enemy_string) {
      let list_of_parameters = 
        enemy_string
          |> string.split(on: "\n")
          |> list.map(fn (parameter) {
            let [key, value] = 
              parameter
                |> string.split(on: ":")
                |> list.map(string.trim)
            #(key, value)
          })
      let parameters_map = 
        map.from_list(list_of_parameters)
      let enemy_type = case parameters_map |> map.get("enemy_type") {
        Ok(value) -> value
        Error(_) -> "Unknown"
      }
      let health = case parameters_map |> map.get("health") {
        Ok(value) -> case float.parse(value) {
          Ok(float_value) -> float_value
          Error(_) -> 10.0
        }
        Error(_) -> 10.0
      }
      let damage = case parameters_map |> map.get("damage") {
        Ok(value) -> case float.parse(value) {
          Ok(float_value) -> float_value
          Error(_) -> 3.0
        }
        Error(_) -> 3.0
      }
      
      Enemy(enemy_type, health, damage)
    })
}
