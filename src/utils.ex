# I'm using this file to
# implement features that are not
# available in Gleam yet

defmodule Utils do
  def clear_terminal, do:
    IO.write("\u001B[H\u001B[2J")
end
