defmodule ReleaseNotesBot.Views.Components.Modal.Block.DynamicField do
  @moduledoc """
  This module is used to populate dynamic modal fields for static-select options
  and possibly checkboxes in the future
  """
  alias ReleaseNotesBot.Views.Components.Modal.Block.Label

  def component(name, id) do
    %{
      text: Label.label(name),
      value: "#{id}"
    }
  end
end
