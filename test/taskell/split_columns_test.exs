defmodule Tl.Taskell.SplitColumnsTest do
  use ExUnit.Case

  setup_all do
    Application.put_env(:tl, :file_module, Tl.FileStub)
    {:ok, []}
  end

  test "call/0" do
    result = Tl.Taskell.SplitColumns.call()
  end
end
