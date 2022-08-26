defmodule ReleaseNotesBotWeb.CaptainsView do
  use ReleaseNotesBotWeb, :view
  alias ReleaseNotesBot.Views.Components.Modal.Header.{Submit, Title, Close}
  alias ReleaseNotesBot.Views.Components.Modal.Block.Input

  def render("ping.json", _data) do
    %{status: "The Captain is on Deck"}
  end

  def new_project(clients) do
    %{
      title: Title.title("Captain's Log"),
      submit: Submit.submit(),
      type: "modal",
      close: Close.close(),
      blocks: [
        Input.static_select(
          "client-select",
          "static_select-action",
          "Select Client",
          "Select an item",
          clients
        ),
        Input.text("create_project", "input_action", "Create a Project", "Enter Project Name")
      ]
    }
  end

  def new_client() do
    %{
      title: Title.title("Captain's Log"),
      submit: Submit.submit(),
      type: "modal",
      close: Close.close(),
      blocks: [
        Input.text("create_client", "input_action", "Create a Client", "Enter Client Name")
      ]
    }
  end

  def gen_client_view(clients) do
    %{
      title: Title.title("Captain's Log"),
      submit: Submit.submit(),
      type: "modal",
      close: Close.close(),
      blocks: [
        Input.static_select(
          "client-select",
          "static_select-action",
          "Select Client",
          "Select an item",
          clients
        )
      ]
    }
  end

  def gen_release_notes_view(projects) do
    %{
      title: Title.title("Release Notes"),
      submit: Submit.submit(),
      type: "modal",
      close: Close.close(),
      blocks: [
        Input.static_select(
          "block-title",
          "select-title-action",
          "Select a Project",
          "Project Name",
          projects
        ),
        Input.text("block-name", "input-name", "Release Name", "Enter the name of the release"),
        Input.text("block-note", "input-notes", "Release Notes", "Type in here", true),
        Input.checkbox("block-here", "checkbox-here", "Should we notify @here?", true, [
          %{
            text: %{
              type: "plain_text",
              text: "Send message"
            },
            value: "value-1"
          }
        ])
      ]
    }
  end
end
