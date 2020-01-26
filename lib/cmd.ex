defmodule Tl.Cmd do
  use GenServer

  def start_link(cmd, args) do
    GenServer.start_link(__MODULE__, [cmd, args])
  end

  @doc """
  GenServer.init/1 callback
  """
  def init([cmd, args] = state) do
    spawn_link(Tl.Cmd, :exec_and_halt, [self(), cmd, args])
    {:ok, state}
  end

  def handle_call(:stop, _from, state),
    do: {:stop, :normal, state}

  def exec([]), do: nil

  def exec(cmd_list) do
    cmd_list
    |> Enum.map(fn {cmd, args} -> Task.async(fn -> exec(cmd, args) end) end)
    |> Enum.map(&Task.await/1)
  end

  def exec(cmd, args) do
    {output, exit_code} = System.cmd(cmd, args)


    log(cmd, exit_code, output)
    {output, exit_code}
  end

  def log(cmd, exit_code, output) do
    Tl.log("cmd", "[cmd: #{cmd}] [exit code: #{exit_code}]: #{output}")
  end

  def exec_and_halt(pid, cmd, args) do
    exec(cmd, args)
    GenServer.call(pid, :stop)
  end
end
