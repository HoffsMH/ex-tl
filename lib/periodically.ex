defmodule Tl.Periodically do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Tl.File.append(Path.expand("~/.tl/2020-01.log"), "we are checking to see if display is down")
    Tl.Startx.cull_if_no_display()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1000)
  end
end
