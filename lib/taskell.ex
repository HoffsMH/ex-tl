defmodule Tl.Taskell do
  def call(["split" | rest]) do
    Tl.Taskell.SplitColumns.call(rest)
  end
end
