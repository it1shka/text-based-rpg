import gleam/io
import hero
import utils

pub fn main() {
  let hero = hero.new()
  utils.clear_console()
  let description = hero.to_string(hero)
  io.println(description)
}
