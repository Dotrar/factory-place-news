defmodule FactoryplaceWeb.CommentController do
  use FactoryplaceWeb, :controller

  alias Factoryplace.Core
  alias Factoryplace.Core.Comment

  @doc """
  reply to a parent comment
  """
  def reply(conn, %{"comment" => %{"body" => body}, "id" => id}) do
    parent = Core.get_comment!(id)

    case Core.create_comment(%{
           body: body,
           depth: parent.depth + 1,
           post_id: parent.post_id,
           parent_id: parent.id
         }) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Replied!")
        |> redirect(to: ~p"/posts/#{comment.post_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :show, %{comment: parent, reply_changeset: changeset})
    end
  end

  @doc """
  Show a comment, if it's ours, let us edit / delete it.
  if it's someone else's, let us reply
  """
  def show(conn, %{"id" => id}) do
    comment = Core.get_comment!(id)

    reply_changeset =
      if comment.depth < Core.max_comment_depth() do
        Core.change_comment(%Comment{}, %{parent: id, post_id: comment.post_id})
      else
        nil
      end

    render(conn, :show, %{comment: comment, reply_changeset: reply_changeset})
  end

  def edit(conn, %{"id" => id}) do
    comment = Core.get_comment!(id)
    changeset = Core.change_comment(comment)
    render(conn, :edit, comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Core.get_comment!(id)

    case Core.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: ~p"/comments/#{comment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Core.get_comment!(id)
    {:ok, _comment} = Core.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: ~p"/")
  end
end
