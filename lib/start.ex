defmodule Tl.Start do
  def call([]), do: call()

  def call() do
    {:ok, startx_pid} = Tl.Start.Supervisor.start_link([])

    receive do
      {:DOWN, _, _, _, _} ->
        IO.puts("Startx is down")
    end
  end
end
