defmodule Exrows.Exyxorp.MixProject do
  use Mix.Project

  def project do
    [
      app: :exyxorp,
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

  defp deps,
    do: [ {:exrows_channel, git: "https://github.com/yauhsien/exrows.git", branch: "main", sparse: "apps/exrows_channel"},
          {:phoenix_pubsub, "~> 2.0"},
          {:typed_struct, "~> 0.2.0"}
        ]
end
