defmodule ReleaseNotesBot.Views.Components.Modal.Block.Element do
  @moduledoc """
  This module is composed of different elements that are used to construct inputs
  """
  alias ReleaseNotesBot.Views.Components.Modal.Block.Label

  @spec plain_text(action_id :: binary, label_text :: binary, multiline :: boolean) ::
          %{
            action_id: binary,
            placeholder: %{emoji: true, text: binary, type: <<_::80>>},
            type: binary,
            multiline: boolean
          }
  def plain_text(action_id, label_text, multiline) do
    %{
      type: "plain_text_input",
      placeholder: Label.label(label_text),
      action_id: action_id,
      multiline: multiline
    }
  end

  @spec element(
          type :: binary,
          action_id :: binary,
          label_text :: binary,
          enumeration :: list(any())
        ) ::
          %{
            action_id: binary,
            options: List,
            placeholder: %{emoji: true, text: binary, type: <<_::80>>},
            type: binary
          }
  def element(type, action_id, label_text, enumeration) do
    %{
      type: type,
      placeholder: Label.label(label_text),
      options: enumeration,
      action_id: action_id
    }
  end

  @spec checkbox(binary, list(any), binary) :: %{
          action_id: binary,
          options: list(any),
          type: binary
        }
  def checkbox(type, action_id, enumeration) do
    %{
      type: type,
      options: enumeration,
      action_id: action_id
    }
  end
end
