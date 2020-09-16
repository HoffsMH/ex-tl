defmodule Tl.Taskell do
  def call(["archive-done" | _rest]) do
    Tl.Taskell.ArchiveDone.call()
  end
end
