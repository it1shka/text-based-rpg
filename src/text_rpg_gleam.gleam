import gleam/io
import hero

pub fn main() {
  let hero = hero.new("Tikhon")
  let description = hero.to_string(hero)
  io.println(description)
}
