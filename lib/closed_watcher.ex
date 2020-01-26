defmodule Tl.ClosedWatcher do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init([fs_args: fs_args, call_mod: call_mod]) do
    {:ok, watcher_pid} = FileSystem.start_link(fs_args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid, call_mod: call_mod }}
  end

  def handle_info(
        {:file_event, _watcher_pid, {_path, [:modified, :closed]}},
        %{call_mod: call_mod} = state
      ) do
    call_mod.call()
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end
end
