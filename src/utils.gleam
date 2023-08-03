import gleam/option as opt
import gleam/iterator as iter
import gleam/int
import gleam/float
import gleam/string
import gleam/list

pub fn index_of(list: List(a), value: a) {
  let result = 
    list 
      |> iter.from_list
      |> iter.index
      |> iter.find(one_that: fn (pair) {
        let #(_, elem) = pair
        elem == value
      })
  case result {
    Error(_) -> opt.None
    Ok(#(index, _)) -> opt.Some(index)
  }
}

const color_list = [
  "black", "red", "green",
  "yellow", "blue", "purple",
  "cyan", "white"
]

pub fn color_of(color: String) -> String {
  let maybe_index = color_list |> index_of(color)
  case maybe_index {
    opt.None if color == "reset" -> "\e[0m"
    opt.None -> "\e[0;30m"
    opt.Some(index) -> "\e[0;3" <> int.to_string(index) <> "m"
  }
}

pub fn paint(original: String, with color: String) -> String {
  let #(start, end) = #(color_of(color), color_of("reset"))
  start <> original <> end
}

pub fn round(value: Float, upto digits: Int) -> Float {
  let ten_powered = case int.power(10, int.to_float(digits)) {
    Error(_) -> 1.0
    Ok(value) -> value
  }
  let result = value 
    |> float.multiply(ten_powered) 
    |> float.round
    |> int.to_float
    |> float.divide(ten_powered)
  case result {
    Error(_) -> value
    Ok(final_result) -> final_result
  }
}

pub fn format_float(value: Float) -> String {
  value 
    |> round(upto: 2)
    |> float.to_string
}

@external(erlang, "Elixir.IO", "gets")
pub fn read_line(message: String) -> String

pub fn read_string(message: String) -> String {
  read_line(message) |> string.trim()
}

const int_warning = "The value you provided is not an integer. "
pub fn read_integer(message: String) -> Int {
  let result = read_string(message) |> int.parse
  case result {
    Error(_) -> read_integer(int_warning <> message)
    Ok(value) -> value
  }
}

const float_warning = "The value you provided is not a float. "
pub fn read_float(message: String) -> Float {
  let result = read_string(message) |> float.parse
  case result {
    Error(_) -> read_float(float_warning <> message)
    Ok(value) -> value
  }
}

pub fn dedent(text: String) -> String {
  text
    |> string.split(on: "\n")
    |> list.map(string.trim)
    |> list.filter(fn (elem) { !string.is_empty(elem) })
    |> string.join(with: "\n")
}

@external(erlang, "Elixir.Utils", "clear_terminal")
pub fn clear_console() -> Nil

@external(erlang, "Elixir.File", "read!")
pub fn read_file(filepath: String) -> String