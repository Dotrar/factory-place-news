defmodule Factoryplace.CoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Factoryplace.Core` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        comment: "some comment that is longer than 15 chars",
        title: "some title to imply content",
        url: "http://google.com/"
      })
      |> Factoryplace.Core.create_post()

    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    post_id =
      case Map.get(attrs, :post_id) do
        nil -> post_fixture().id
        id -> id
      end

    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body",
        post_id: post_id,
        depth: 0
      })
      |> Factoryplace.Core.create_comment()

    comment
  end
end
