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
      valid_attrs = %{
        title: "some longer title than is needed",
        comment: "some comment",
        url: "https://youtube.com/"
      }

      assert {:ok, %Post{} = post} = Core.create_post(valid_attrs)
      assert post.title == "some longer title than is needed"
      assert post.comment == "some comment"
      assert post.url == "https://youtube.com/"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()

      update_attrs = %{
        title: "some updated title that is also longer",
        comment: "some updated comment",
        url: "https://reddit.com/"
      }

      assert {:ok, %Post{} = post} = Core.update_post(post, update_attrs)
      assert post.title == "some updated title that is also longer"
      assert post.comment == "some updated comment"
      assert post.url == "https://reddit.com/"
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

  describe "comments" do
    alias Factoryplace.Core.Comment

    import Factoryplace.CoreFixtures

    @invalid_attrs %{body: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Core.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Core.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{body: "some body"}

      assert {:ok, %Comment{} = comment} = Core.create_comment(valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Comment{} = comment} = Core.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_comment(comment, @invalid_attrs)
      assert comment == Core.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Core.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Core.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Core.change_comment(comment)
    end
  end
end
