import gleam/io
import hero

pub fn main() {
  let hero = hero.new()
  let description = hero.to_string(hero)
  io.println(description)
}
