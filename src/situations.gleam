import utils
import gleam/string
import gleam/list
import enemy.{Enemy}
import hero.{Hero}

pub fn read_situations(filepath: String) -> List(String) {
  let raw_lines = 
    utils.read_file(filepath)
      |> string.split(on: "%%")
      |> list.map(string.trim)
      |> list.filter(fn (elem) { !string.is_empty(elem) })
  list.map(raw_lines, fn(line) {
    line
      |> string.split("\n")
      |> list.map(string.trim)
      |> string.join(with: "\n")
  })
}

pub fn compile_situation(situation: String, hero: Hero, enemy: Enemy) -> String {
  let hero_description = hero |> hero.to_string()
  let enemy_description = enemy |> enemy.to_string()
  situation
    |> string.replace("{hero}", hero_description)
    |> string.replace("{enemy}", enemy_description)
}

