defmodule Tl.FileStub do
  def append(_filename, content),
    do: content

  def read(_filename),
    do: "test content"

  def overwrite(_filename, content),
    do: content
end
