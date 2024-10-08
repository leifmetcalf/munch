defmodule MunchWeb.PageController do
  use MunchWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
