defmodule ExrowsWeb.PageController do
  use ExrowsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
