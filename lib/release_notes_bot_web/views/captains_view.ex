defmodule ReleaseNotesBotWeb.CaptainsView do
  use ReleaseNotesBotWeb, :view

  def render("ping.json", _data) do
    %{status: "The Captain is on Deck"}
  end

  def render("postResponse.json", %{data: data}) when is_struct(data) do
    %{echo: data}
  end

  def render("postErrorResponse.json", %{data: data}) when is_struct(data) do
    %{error: data}
  end
end
