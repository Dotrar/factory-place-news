defmodule Factoryplace.CoreTest do
  use Factoryplace.DataCase

  alias Factoryplace.Core

  describe "posts" do
    alias Factoryplace.Core.Post

    import Factoryplace.CoreFixtures

    @invalid_attrs %{title: nil, comment: nil, url: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Core.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Core.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{title: "some title", comment: "some comment", url: "some url"}

      assert {:ok, %Post{} = post} = Core.create_post(valid_attrs)
      assert post.title == "some title"
      assert post.comment == "some comment"
      assert post.url == "some url"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{title: "some updated title", comment: "some updated comment", url: "some updated url"}

      assert {:ok, %Post{} = post} = Core.update_post(post, update_attrs)
      assert post.title == "some updated title"
      assert post.comment == "some updated comment"
      assert post.url == "some updated url"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_post(post, @invalid_attrs)
      assert post == Core.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Core.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Core.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Core.change_post(post)
    end
  end
end
