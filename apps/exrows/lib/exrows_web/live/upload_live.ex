defmodule ExrowsWeb.UploadLive do
  use ExrowsWeb, :live_view
  require EEx
  require Phoenix.LiveView.Helpers

  @avatar_upload :"avatar upload"
  @config_upload :"config upload"

  @impl Phoenix.LiveView
  def render(assigns) do
    if assigns.doing == @avatar_upload do
      render_avatar_uploaded(assigns)
    else if assigns.doing == @config_upload do
      render_config_uploaded(assigns)
    else if assigns.doing == :nothing do
      render_heex(assigns)
    end end end
  end

  EEx.function_from_file(
    :defp, :render_heex,
    "#{File.cwd!()}/lib/exrows_web/live/upload_live.html.heex",
    [:assigns],
    engine: Phoenix.LiveView.HTMLEngine)

  EEx.function_from_file(
    :defp, :render_avatar_uploaded,
    "#{File.cwd!()}/lib/exrows_web/live/avatar_uploaded.html.heex",
    [:assigns],
    engine: Phoenix.LiveView.HTMLEngine)

  EEx.function_from_file(
    :defp, :render_config_uploaded,
    "#{File.cwd!()}/lib/exrows_web/live/config_uploaded.html.heex",
    [:assigns],
    engine: Phoenix.LiveView.HTMLEngine)

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:doing, :nothing)
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 2)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:exrows), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}
      end)
    {:noreply, update(socket
    |> assign(:doing, @avatar_upload), :uploaded_files, &(&1 ++ uploaded_files))}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
