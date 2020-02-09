defmodule Tl.Taskell do
  def call(["split" | rest]) do
    Tl.Taskell.SplitColumns.call(rest)
  end

  def call(["archive-done" | _rest]) do
    Tl.Taskell.ArchiveDone.call()
  end
end
