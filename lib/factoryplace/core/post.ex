defmodule Factoryplace.Core.Post do
  alias Factoryplace.Core.Comment
  use Ecto.Schema
  import Ecto.Changeset
  import EctoCommons.URLValidator

  schema "posts" do
    field :title, :string
    field :comment, :string
    field :url, :string
    has_many :comments, Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :url, :comment])
    |> validate_required([:title])
    |> validate_length(:title, min: 12)
    |> validate_url(:url)
    |> validate_one_of(:url, :comment)
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
