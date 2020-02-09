defmodule Tl.MockCmd do
  def exec(cmd, args) do
    {cmd, args}
  end
end

defmodule Tl.Bw.CpTest do
  use ExUnit.Case

  test "#call" do
    Application.put_env(:tl, :cmd_module, Tl.MockCmd)
  end
end
