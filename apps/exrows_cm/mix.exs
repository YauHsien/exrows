defmodule Exrows.ConfigurationManagement.MixProject do
  use Mix.Project

  def project do
    [
      app: :exrows_cm,
      version: "0.1.0",
      elixir: "~> 1.14-rc",
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
      {:fast_yaml, "~> 1.0.33"}
    ]
  end
end
