# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :release_notes_bot,
  ecto_repos: [ReleaseNotesBot.Repo]

# Configures the endpoint
config :release_notes_bot, ReleaseNotesBotWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ReleaseNotesBotWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ReleaseNotesBot.PubSub,
  live_view: [signing_salt: "FJtjpwb7"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :release_notes_bot, ReleaseNotesBot.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure the Slack Bot
config :release_notes_bot,
  slack_bot_token: System.get_env("SLACK_BOT_TOKEN")

config :slack, api_token: System.get_env("SLACK_BOT_TOKEN")

config :release_notes_bot, slack_blast_channel: System.get_env("SLACK_BLAST_CHANNEL")

config :release_notes_bot, confluence_space_key: System.get_env("CONFLUENCE_SPACE_KEY")

config :release_notes_bot, confluence_space_id: System.get_env("CONFLUENCE_SPACE_ID")

config :release_notes_bot, confluence_parent_id: System.get_env("CONFLUENCE_PARENT_ID")

config :release_notes_bot, confluence_email: System.get_env("CONFLUENCE_EMAIL")

config :release_notes_bot, confluence_api_key: System.get_env("CONFLUENCE_API_KEY")

config :release_notes_bot, client_secret: System.get_env("CLIENT_SECRET")

config :release_notes_bot, client_id: System.get_env("CLIENT_ID")

config :release_notes_bot, oauth_redirect_uri: System.get_env("OAUTH_REDIRECT_URI")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
