defmodule FactoryplaceWeb.PostController do
  use FactoryplaceWeb, :controller

  alias Factoryplace.Core
  alias Factoryplace.Core.Post
  alias Factoryplace.Core.Comment

  def index(conn, _params) do
    posts = Core.list_posts()
    render(conn, :index, posts: posts)
  end

  def new(conn, _params) do
    changeset = Core.change_post(%Post{})
    render(conn, :new, changeset: changeset)
  end

  def create(%{assigns: %{current_user: user}} = conn, %{"post" => post_params}) do
    post_params = Map.put(post_params, :user, user)

    case Core.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Core.get_post!(id)
    comment_changeset = Core.change_comment(%Comment{}, %{post_id: id})

    comment_hierachy =
      for comment <- post.comments,
          reduce: %{nil: []} do
        acc ->
          Map.update(acc, comment.parent_id, [comment], &[comment | &1])
      end

    render(conn, :show, %{
      post: post,
      comment_changeset: comment_changeset,
      comment_hierachy: comment_hierachy
    })
  end

  def edit(conn, %{"id" => id}) do
    post = Core.get_post!(id)
    changeset = Core.change_post(post)
    render(conn, :edit, post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Core.get_post!(id)

    case Core.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Core.get_post!(id)
    {:ok, _post} = Core.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: ~p"/posts")
  end

  def comment(%{assigns: %{current_user: user}} = conn, %{
        "comment" => %{"body" => body},
        "id" => post_id
      }) do
    case Core.create_comment(%{body: body, post_id: post_id, depth: 0, user_id: user.id}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Thanks for your comment #{user.username}.")
        |> redirect(to: ~p"/posts/#{post_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
