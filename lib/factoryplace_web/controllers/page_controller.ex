defmodule FactoryplaceWeb.PageController do
  use FactoryplaceWeb, :controller
  alias Factoryplace.Core

  def home(conn, _params) do
    posts = Core.list_posts()
    render(conn, :home, posts: posts)
  end

  def about(conn, _params), do: render(conn, :about)
end
