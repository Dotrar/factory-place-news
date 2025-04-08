defmodule Factoryplace.Core.Comment do
  alias Factoryplace.Core.{Post, Comment}
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :depth, :integer
    belongs_to :post, Post
    belongs_to :parent, Comment
    has_many :replies, Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id])
    |> validate_required([:body, :post_id])
  end
end
