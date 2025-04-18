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
        comment: "some comment",
        title: "some longer title to imply content",
        url: "http://google.com/"
      })
      |> Factoryplace.Core.create_post()

    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> Factoryplace.Core.create_comment()

    comment
  end
end
