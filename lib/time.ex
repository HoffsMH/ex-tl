defmodule Tl.Time do
  def datestamp() do
    Timex.now()
    |> Timex.format!("%F", :strftime)
  end
end
