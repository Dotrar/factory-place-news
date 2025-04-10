defmodule Factoryplace.CoreTest do
  use Factoryplace.DataCase

  alias Factoryplace.Core

  describe "posts" do
    alias Factoryplace.Core.Post

    import Factoryplace.CoreFixtures

    @invalid_attrs %{title: nil, comment: nil, url: nil}

    test "list_posts/0 returns all posts with comment count" do
      post = post_fixture()
      comment_fixture(%{post_id: post.id})
      comment_fixture(%{post_id: post.id})
      comment_fixture(%{post_id: post.id})

      posts = Core.list_posts()
      assert length(posts) == 1
      post = Enum.at(posts, 0)
      post.comments_count == 3
    end

    test "list_posts/0 returns all posts regardless of comments" do
      comment_fixture()
      post_fixture()

      posts = Core.list_posts()
      assert length(posts) == 2
      Enum.map(posts, fn p -> p.comments_count end) == [0, 1]
    end

    test "get_post!/1 returns the post and comments" do
      comment = comment_fixture()

      assert Core.get_post!(comment.post_id).comments == [comment]
    end

    test "create_post/1 with url and comment" do
      valid_attrs = %{
        title: "some longer title than is needed",
        comment: "some big comment that warrants discussion",
        url: "https://youtube.com/"
      }

      assert {:ok, %Post{} = post} = Core.create_post(valid_attrs)
      assert post.title == "some longer title than is needed"
      assert post.comment == "some big comment that warrants discussion"
      assert post.url == "https://youtube.com/"
    end

    test "create_post/1 with url only" do
      valid_attrs = %{
        title: "some longer title than is needed",
        url: "https://youtube.com/"
      }

      assert {:ok, %Post{} = post} = Core.create_post(valid_attrs)
      assert post.title == "some longer title than is needed"
      assert post.url == "https://youtube.com/"
    end

    test "create_post/1 with comment only" do
      valid_attrs = %{
        title: "some longer title than is needed",
        comment: "some big comment that warrants discussion"
      }

      assert {:ok, %Post{} = post} = Core.create_post(valid_attrs)
      assert post.title == "some longer title than is needed"
      assert post.comment == "some big comment that warrants discussion"
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

    test "get_comment!/1 returns the comment with parent post" do
      comment = comment_fixture()

      assert String.length(Core.get_comment!(comment.id).post.title) > 1
    end

    test "create_comment/1 with valid data creates a comment" do
      post = post_fixture()
      valid_attrs = %{body: "some body", post_id: post.id, depth: 0}

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
      # re-get the comment to repload post data
      comment = Core.get_comment!(comment.id)
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
