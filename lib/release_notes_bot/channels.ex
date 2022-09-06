defmodule ReleaseNotesBot.Channels do
  @moduledoc """
  These are the Repo functions for Channels
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.Channel

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
    case get(slack_id: slack_id) do
      nil ->
        if not parse_dm(slack_name) and not parse_group_dm(slack_name) do
          create(%{"slack_id" => slack_id, "name" => slack_name})
        end

        nil

      _ ->
        nil
    end
  end

  @spec parse_dm(binary) :: boolean
  def parse_dm("directmessage"), do: true

  def parse_dm(_channel), do: false

  @spec parse_group_dm(binary) :: boolean
  def parse_group_dm(channel_name) do
    String.starts_with?(channel_name, "mpdm")
  end
end