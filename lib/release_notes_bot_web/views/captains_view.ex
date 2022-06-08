defmodule ReleaseNotesBotWeb.CaptainsView do
  use ReleaseNotesBotWeb, :view

  def render("ping.json", _data) do
    %{status: "The Captain is on Deck"}
  end

  def gen_client_view(clients) do
    options = Enum.map(clients, fn x -> dynamic_gen_static_select(x.name, x.id) end)

    %{
      title: %{
        type: "plain_text",
        text: "Captain's Log"
      },
      submit: %{
        type: "plain_text",
        text: "Submit"
      },
      type: "modal",
      close: %{
        type: "plain_text",
        text: "Cancel"
      },
      blocks: [
        %{
          type: "input",
          block_id: "client-select",
          element: %{
            type: "static_select",
            placeholder: %{
              type: "plain_text",
              text: "Select an item",
              emoji: true
            },
            options: options,
            action_id: "static_select-action"
          },
          label: %{
            type: "plain_text",
            text: "Select Client"
          },
          optional: false
        }
      ]
    }
  end

  def gen_release_notes_view(projects) do
    options = Enum.map(projects, fn x -> dynamic_gen_static_select(x.name, x.id) end)

    %{
      title: %{
        type: "plain_text",
        text: "Release Notes"
      },
      submit: %{
        type: "plain_text",
        text: "Submit"
      },
      type: "modal",
      close: %{
        type: "plain_text",
        text: "Cancel"
      },
      blocks: [
        %{
          type: "input",
          block_id: "block-title",
          element: %{
            type: "static_select",
            placeholder: %{
              type: "plain_text",
              text: "Project Name"
            },
            options: options,
            action_id: "select-title-action"
          },
          label: %{
            type: "plain_text",
            text: "Select a Project"
          }
        },
        %{
          type: "input",
          block_id: "block-name",
          label: %{
            type: "plain_text",
            text: "Release Name"
          },
          element: %{
            type: "plain_text_input",
            action_id: "input-name",
            placeholder: %{
              type: "plain_text",
              text: "Enter the name of the release"
            },
            multiline: false
          },
          optional: false
        },
        %{
          type: "input",
          block_id: "block-note",
          label: %{
            type: "plain_text",
            text: "Release Notes"
          },
          element: %{
            type: "plain_text_input",
            action_id: "input-notes",
            placeholder: %{
              type: "plain_text",
              text: "Type in here"
            },
            multiline: true
          },
          optional: true
        },
        %{
          type: "input",
          block_id: "block-here",
          optional: true,
          element: %{
            type: "checkboxes",
            options: [
              %{
                text: %{
                  type: "plain_text",
                  text: "Send message"
                },
                value: "value-1"
              }
            ],
            action_id: "checkbox-here"
          },
          label: %{
            type: "plain_text",
            text: "Should we notify @here?"
          }
        }
      ]
    }
  end

  defp dynamic_gen_static_select(name, id) do
    %{
      text: %{
        type: "plain_text",
        text: name
      },
      value: "#{id}"
    }
  end
end
