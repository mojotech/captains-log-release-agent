defmodule ReleaseNotesBot.Channels do
  @moduledoc """
  These are the Repo functions for Channels
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.Channel
  alias __MODULE__

  def create(params) do
    %Channel{}
    |> Channel.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(Channel)
  end

  # Get a note by one specific field
  # param ex: (name: "mojotech") or (id: 4)
  def get(param) do
    Repo.get_by(Channel, param)
  end

  @spec register(binary, binary) :: nil
  def register(slack_name, slack_id) do
    case Channels.get(slack_id: slack_id) do
      nil ->
        if not parse_dm(slack_name) and not parse_group_dm(slack_name) do
          create(%{"slack_id" => slack_id, "name" => slack_name})
        end

        nil

      _ ->
        nil
    end
  end

  def update(channel, params) do
    channel
    |> Channel.changeset(params)
    |> Repo.update()
  end

  def get_client(param) do
    Channel
    |> Repo.get_by(param)
    |> Repo.preload([:client])
  end

  def post_ephemeral(channel, message, target_user_id) do
    Slack.Web.Chat.post_ephemeral(
      channel,
      message,
      target_user_id
    )
  end

  def post_message(channel, message) do
    Slack.Web.Chat.post_message(
      channel,
      message
    )
  end

  def post_blast_message(message) do
    Task.async(fn ->
      post_message(Application.get_env(:release_notes_bot, :slack_blast_channel), message)
    end)
  end

  def post_message_all_client_channels(client_with_channels, message) do
    Enum.each(client_with_channels.channels, fn c ->
      Task.async(fn -> post_message(c.slack_id, message) end)
    end)

    # This sends the message to the slack channel that is used for temporary internal logging and QA
    post_blast_message(message)
  end

  @spec parse_dm(binary) :: boolean
  def parse_dm("directmessage"), do: true

  def parse_dm(_channel), do: false

  @spec parse_group_dm(binary) :: boolean
  def parse_group_dm(channel_name) do
    String.starts_with?(channel_name, "mpdm")
  end
end
