defmodule ReleaseNotesBot.Views.Components.Modal.Header.Submit do
  @moduledoc """
  This module is used to template the submit component is modal headers
  """
  @spec submit :: %{text: <<_::48>>, type: <<_::80>>}
  def submit do
    %{
      type: "plain_text",
      text: "Submit"
    }
  end
end
