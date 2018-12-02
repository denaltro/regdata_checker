defmodule RegdataCheckerWeb.PageController do
  use RegdataCheckerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
