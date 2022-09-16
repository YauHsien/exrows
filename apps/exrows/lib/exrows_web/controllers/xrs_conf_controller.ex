defmodule ExrowsWeb.XRSConfController do
  use ExrowsWeb, :controller

  def load(conn, params) do
    file = Map.get(params, "file")
    {state0, content0, error0} =
      case File.read(file) do
        {:ok, content} -> {:ok, content, nil}
        {:error, error} -> {:error, nil, error}
      end
    {state, content, error} =
      case Exrows.ConfigurationManagement.load_from_file(file) do
        {:ok, content} -> {:ok, content, nil}
        {:error, error} -> {:bad, nil, error}
      end
    render(conn, "loaded.html",
      state0: state0, content0: content0, error0: error0,
      state: state, content: content, error: error,
      file: file)
  end
end
