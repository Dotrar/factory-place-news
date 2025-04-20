defmodule Factoryplace.Core.Post do
  alias Factoryplace.Core.Comment
  alias Factoryplace.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset
  import EctoCommons.URLValidator

  schema "posts" do
    field :title, :string
    field :comment, :string
    field :url, :string
    belongs_to :user, User
    has_many :comments, Comment

    field :comments_count, :integer, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :url, :comment, :user_id])
    |> validate_required([:title, :user_id])
    |> validate_one_of(:url, :comment)
    |> validate_length(:comment, min: 15)
    |> validate_url(:url)
  end

  defp validate_one_of(changeset, a, b) do
    case get_field(changeset, b) do
      nil ->
        validate_required(changeset, a,
          message: "You need either a comment or a URL to be populated"
        )

      _ ->
        changeset
    end
  end
end
