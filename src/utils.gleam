import gleam/option as opt
import gleam/iterator as iter
import gleam/int
import gleam/float

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