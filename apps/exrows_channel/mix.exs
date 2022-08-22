defmodule Exrows.Channel.MixProject do
  use Mix.Project

  def project,
    do: [ app: :exrows_channel,
          version: "1.0.0",
          elixir: "~> 1.14-rc",
          start_permanent: Mix.env() == :prod,
          deps: deps()
        ]

  def application, do: []

  defp deps,
    do: [ {:phoenix_pubsub, "~> 2.0"},
          {:typed_struct, "~> 0.2.0"}
        ]
end
