defmodule Tl.FakeCmd do
  def exec(cmd, args) do
    {cmd, args}
  end
end

defmodule FakeFile do
  def cwd!(), do: "."
  def cd!(_), do: :ok
  def rm!(_), do: :ok
end

defmodule Tl.JrnlTest do
  use ExUnit.Case


  test "#lock" do
    Application.put_env(:tl, :cmd_module, Tl.FakeCmd)
    Application.put_env(:tl, :file_module, FakeFile)

    result = Tl.Jrnl.call(["lock"])

    require IEx; IEx.pry
  end
end
