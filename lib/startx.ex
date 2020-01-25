defmodule Tl.Startx do
  def call(_args), do: call()

  def call() do
    log("startx.call has been called!")
    Tl.Startx.RunOnce.call()

    Tl.Startx.Supervisor.start_link(name: Tl.Startx.Supervisor)
  end

  def cull_if_no_display() do
    log("we are checking to see if display is down")
    cond do
      !detect_display()  && Process.whereis(Tl.Startx.Supervisor) ->
        log("We are stopping the Supervisor")
        Supervisor.stop(Tl.Startx.Supervisor, :normal)

      detect_display() && !Process.whereis(Tl.Startx.Supervisor) ->
        log("we are starting the supervisor back up")
        call()


      true ->
        log("somehow neither condition was true")
        log("heres detect_display #{detect_display}")
        log("heres processwhereis #{Process.whereis(Tl.Startx.Supervisor)}")
        log("here is that :os ps command #{detect_display_bak()}")
        nil
    end
  end

  def log(text) do
    Tl.File.append(Path.expand("~/.tl/2020-01.log"), text)
  end

  def detect_display_bak() do
    :os.cmd('ps -e | grep tty')
  end

  def detect_display() do
    :os.cmd('ps -e | grep tty')
    |> to_string
    |> String.match?(~r{Xorg})
  end
end
