defmodule Tl.MixProject do
  use Mix.Project

  def project do
    [
      app: :tl,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
      elixirc_paths: compiler_paths(Mix.env())
    ]
  end

  def compiler_paths(:test), do: ["test/support"] ++ compiler_paths(:prod)
  def compiler_paths(_), do: ["lib"]

  def application do
    [
      mod: {Tl.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [main_module: Tl.CLI]
  end

  defp deps do
    [
      {:file_system, "~> 0.2"},
      {:timex, "~> 3.5"},
      {:quantum, "~> 2.3"},
      {:poison, "~> 4.0"},
      {:tzdata, path: "vendor/tzdata", override: true},
    ]
  end
end
