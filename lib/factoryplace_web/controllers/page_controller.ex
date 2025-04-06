defmodule FactoryplaceWeb.PageController do
  use FactoryplaceWeb, :controller
  alias Factoryplace.Core

  def home(conn, _params) do
    posts = Core.list_posts()
    render(conn, :home, posts: posts)
  end
end
