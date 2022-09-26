defmodule ReleaseNotesBot.Views.Components.Modal.Block.Input do
  @moduledoc """
  This module consists of different input method components
  """
  alias ReleaseNotesBot.Views.Components.Modal.Block.{Label, Element, DynamicField}
  @moduletype "input"

  @spec text(
          block_id :: binary,
          action_id :: binary,
          top_label :: binary,
          element_label :: binary,
          multiline :: boolean
        ) :: %{
          block_id: any,
          element: %{
            action_id: binary,
            multiline: boolean,
            placeholder: %{emoji: true, text: binary, type: binary},
            type: binary
          },
          label: %{emoji: true, text: binary, type: binary},
          optional: false,
          type: binary
        }
  def text(block_id, action_id, top_label, element_label, multiline \\ false, optional \\ false) do
    %{
      type: @moduletype,
      block_id: block_id,
      optional: optional,
      element: Element.plain_text(action_id, element_label, multiline),
      label: Label.label(top_label)
    }
  end

  @spec static_select(
          block_id :: binary,
          action_id :: binary,
          top_label :: binary,
          element_label :: binary,
          enumerable :: list(any())
        ) :: %{
          block_id: binary,
          element: %{
            action_id: binary,
            options: List,
            placeholder: %{emoji: true, text: binary, type: binary},
            type: binary
          },
          label: %{emoji: true, text: binary, type: binary},
          optional: false,
          type: binary
        }
  def static_select(block_id, action_id, top_label, element_label, enumerable) do
    %{
      type: @moduletype,
      block_id: block_id,
      optional: false,
      element:
        Element.element(
          "static_select",
          action_id,
          element_label,
          Enum.map(enumerable, fn x -> DynamicField.component(x.name, x.id) end)
        ),
      label: Label.label(top_label)
    }
  end

  @spec checkbox(
          block_id :: binary,
          action_id :: binary,
          top_label :: binary,
          option :: boolean,
          checklist :: [any]
        ) :: %{
          block_id: binary,
          element: %{action_id: binary, options: [any], type: binary},
          label: %{emoji: true, text: binary, type: binary},
          optional: boolean,
          type: binary
        }
  def checkbox(block_id, action_id, top_label, option, checklist) do
    %{
      type: @moduletype,
      block_id: block_id,
      optional: option,
      label: Label.label(top_label),
      element:
        Element.checkbox(
          "checkboxes",
          action_id,
          checklist
        )
    }
  end
end
