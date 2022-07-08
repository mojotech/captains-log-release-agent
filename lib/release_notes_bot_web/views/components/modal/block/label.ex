defmodule ReleaseNotesBot.Views.Components.Modal.Block.Label do
  @moduledoc """
  This module is used to generate labels for components
  """
  @spec label(binary) :: %{emoji: true, text: binary, type: <<_::80>>}
  def label(label) do
    %{
      type: "plain_text",
      text: label,
      emoji: true
    }
  end
end
