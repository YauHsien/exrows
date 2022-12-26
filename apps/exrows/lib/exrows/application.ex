defmodule Exrows.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Exrows.Repo,
      # Start the Telemetry supervisor
      ExrowsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Exrows.PubSub},
      %{ id: :event_stream_worker,
         start: {Phoenix.PubSub.Supervisor, :start_link, [[name: :event_stream]]}
      },
      {Registry, keys: :unique, name: :event_store},
      # Start the Endpoint (http/https)
      ExrowsWeb.Endpoint
      # Start a worker by calling: Exrows.Worker.start_link(arg)
      # {Exrows.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exrows.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExrowsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
