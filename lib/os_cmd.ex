defmodule Tl.OsCmd do
  use GenServer

  def start_link(cmd) do
    GenServer.start_link(__MODULE__, [cmd])
  end

  @doc """
  GenServer.init/1 callback
  """
  def init([cmd] = state) do
    spawn_link(Tl.OsCmd, :exec_and_halt, [self(), cmd])
    {:ok, state}
  end

  def handle_call(:stop, _from, state),
    do: {:stop, :normal, state}

  def exec(cmd) do
    log("attempting os_cmd: #{cmd}")

    output = :os.cmd(String.to_charlist(cmd))

    log(cmd, output)
    output
  end

  def log(cmd, output) do
    Tl.log("os_cmd", "[os_cmd: #{cmd}]: #{output}")
  end

  def log(text) do
    Tl.log("os_cmd", text)
  end

  def exec_and_halt(pid, cmd) do
    exec(cmd)
    GenServer.call(pid, :stop)
  end
end
