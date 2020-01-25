defmodule Tl.Time do
  def datestamp() do
    Timex.now()
    |> Timex.format!("%F", :strftime)
  end

  def monthstamp() do
    Timex.now()
    |> Timex.format!("%Y-%m", :strftime)
  end

  def iso() do
    Timex.now()
    |> Timex.format!("{ISO:Extended}")
  end
end
