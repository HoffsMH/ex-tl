defmodule Tl.MockCmd do
  def exec(cmd, args) do
    {cmd, args}
  end
end

defmodule MockFile do
  def cwd!(), do: "."
  def cd!(_), do: :ok
  def rm!(_), do: :ok
end

defmodule MockPath do
  def wildcard(_), do: []
  def expand(_), do: "."
end

defmodule Tl.JrnlTest do
  use ExUnit.Case

  test "#lock" do
    Application.put_env(:tl, :cmd_module, Tl.MockCmd)
    Application.put_env(:tl, :file_module, MockFile)
    Application.put_env(:tl, :path_module, MockPath)

    result = Tl.Jrnl.call(["lock"])

    require IEx; IEx.pry
  end
end
