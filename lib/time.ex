defmodule Tl.Time do
  def now() do
    Timex.now()
    |> Timex.Timezone.convert(fake_tz)
  end

  def datestamp() do
    now()
    |> Timex.format!("%F", :strftime)
  end

  def monthstamp() do
    now()
    |> Timex.format!("%Y-%m", :strftime)
  end

  def hours_minutes() do
    now()
    |> Timex.format!("%r", :strftime)
  end

  def iso() do
    now()
    |> Timex.format!("{ISO:Extended}")
  end

  def get_system_offset do
    :os.cmd('date +%z')
    |> List.to_string()
    |> String.trim()
    |> String.slice(0, 3)
    |> String.to_integer()
  end

  def fake_tz do
    Elixir.Timex.TimezoneInfo.create(
      "localTime",
      "LOC",
      60 * 60 * get_system_offset,
      0,
      :min,
      :max
    )
  end
end
