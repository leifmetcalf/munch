defmodule Munch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MunchWeb.Telemetry,
      Munch.Repo,
      {Oban, Application.get_env(:munch, Oban)},
      {DNSCluster, query: Application.get_env(:munch, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Munch.PubSub},
      # Start a worker by calling: Munch.Worker.start_link(arg)
      # {Munch.Worker, arg},
      # Start to serve requests, typically the last entry
      MunchWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Munch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MunchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
