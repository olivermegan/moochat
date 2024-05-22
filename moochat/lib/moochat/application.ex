defmodule Moochat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MoochatWeb.Telemetry,
      Moochat.Repo,
      {DNSCluster, query: Application.get_env(:moochat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Moochat.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Moochat.Finch},
      # Start a worker by calling: Moochat.Worker.start_link(arg)
      # {Moochat.Worker, arg},
      # Start to serve requests, typically the last entry
      MoochatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Moochat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MoochatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
