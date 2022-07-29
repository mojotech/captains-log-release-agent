defmodule ReleaseNotesBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ReleaseNotesBot.Repo,
      # Start the Telemetry supervisor
      ReleaseNotesBotWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ReleaseNotesBot.PubSub},
      # Start the Endpoint (http/https)
      ReleaseNotesBotWeb.Endpoint,
      # Start a worker by calling: ReleaseNotesBot.Worker.start_link(arg)
      # {ReleaseNotesBot.Worker, arg}
      {Finch, name: ReleaseNotesBot.Finch}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReleaseNotesBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReleaseNotesBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
