defmodule Utils do
  def clear_terminal, do:
    IO.write("\u001B[H\u001B[2J")
end
