defmodule ReleaseNotesBot.Views.Components.Modal.Header.Close do
  @moduledoc """
  This module is used to template the close component is modal headers
  """
  @spec close :: %{text: <<_::48>>, type: <<_::80>>}
  def close do
    %{
      type: "plain_text",
      text: "Cancel"
    }
  end
end
