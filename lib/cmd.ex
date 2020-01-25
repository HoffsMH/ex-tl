defmodule Tl.Cmd do
  use GenServer

  def log_dir(),
    do: Application.get_env(:tl, :cmd)[:logfile_dir]

  def current_log_file() do
    Path.expand(Tl.Time.monthstamp() <> ".log", Path.expand(log_dir))
  end

  def log_prefix(exit_code, cmd, args) do
    "[#{Tl.Time.iso()}] [context] [#{cmd}, #{args}] [#{exit_code}]: "
  end

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

    Tl.Startx.log("we are starting out cmd list")
    cmd_list
    |> Enum.map(fn cmd -> Task.async(fn -> os_exec(cmd) end) end)
    |> Enum.map(&Task.await/1)
  end

  def os_exec(cmd) do
    Tl.Startx.log("starting to form env_shim")
    env_shim = :os.cmd('env')
    |> to_string
    |> String.split("\n")
    |> Enum.reject(&(String.match?(&1, ~r{SPACESHIP_CHAR_SYMBOL})))
    |> Enum.reject(&(String.match?(&1, ~r{FZF_DEFAULT_OPTS})))
    |> Enum.reject(&(!String.match?(&1, ~r{=})))
    |> Enum.map(&String.split(&1, "="))
    |> Enum.map(fn [varname | rest] ->
      [varname, Enum.join(rest)]
    end)
    |> Enum.map(fn [varname, value] ->
      new_value = String.replace(value, "\"", "'")
      "export " <> varname <> "=" <> "\"#{new_value}\"" <> "\n"
    end)
    # |> Enum.map(&)
    # |> Enum.map(&("export " <> &1 <> "\n"))
    |> Enum.join
    |> to_charlist

    Tl.Startx.log("env_shim is #{env_shim}")

    result = env_shim ++ ' ' ++ cmd
    |> :os.cmd()
    result
    Tl.Startx.log("os_exec #{cmd} : #{result}")

    # Tl.Startx.log("#{cmd} : #{:os.cmd(cmd)}")
    # Process.sleep(1000)
    # os_exec(cmd)
  end

  def exec(cmd, args) do
    {output, exit_code} = System.cmd(cmd, args)

    Tl.File.append(current_log_file(), log_prefix(exit_code, cmd, args) <> output)
    {output, exit_code}
  end

  def exec_and_halt(pid, cmd, args) do
    IO.inspect("cmd: #{cmd}, args: #{args}")
    exec(cmd, args)
    GenServer.call(pid, :stop)
  end
end
