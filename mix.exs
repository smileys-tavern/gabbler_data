defmodule GabblerData.MixProject do
  use Mix.Project

  def project do
    [
      app: :gabbler_data,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_ecto, "~> 4.0"},
      {:hashids, "~> 2.0"},
      {:decimal, "~> 1.8"},
      {:postgrex, "~> 0.15.1"},
      {:ecto_sql, "~> 3.2"}
    ]
  end
end
