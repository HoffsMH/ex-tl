defmodule Tl.Cmd do
  use GenServer

  def start_link(cmd, args) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [cmd, args])

    spawn_link(Tl.Cmd, :perform_cmd_and_halt, [pid, cmd, args])

    {:ok, pid}
  end

  @doc """
  GenServer.init/1 callback
  """
  def init(state), do: {:ok, state}

  def handle_call(:stop, _from, state),
    do: {:stop, :normal, state}

  def perform_cmds([]), do: nil

  def perform_cmds([{cmd, args} | rest]),
    do: perform_cmd(cmd, args)

  def perform_cmd(cmd, args),
    do: IO.inspect(System.cmd(cmd, args))

  def perform_cmd_and_halt(pid, cmd, args) do
    perform_cmd(cmd, args)
    GenServer.call(pid, :stop)
  end
end
