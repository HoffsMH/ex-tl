defmodule Watcher do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, [:modified, :closed]}}, %{watcher_pid: watcher_pid} = state) do
    # YOUR OWN LOGIC FOR PATH AND EVENTS
    IO.inspect(path)
    IO.inspect(state)

    File.write!("log", IO.inspect(path))
    File.write!("log", IO.inspect(state))

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    # YOUR OWN LOGIC WHEN MONITOR STOP
    {:noreply, state}
  end
end
