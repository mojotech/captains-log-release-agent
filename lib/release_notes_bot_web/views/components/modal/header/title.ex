defmodule ReleaseNotesBot.Views.Components.Modal.Header.Title do
  @moduledoc """
  This module is used to template the title component is modal headers
  """
  @spec title(binary) :: %{text: binary, type: <<_::80>>}
  def title(name) do
    %{
      type: "plain_text",
      text: name
    }
  end
end
