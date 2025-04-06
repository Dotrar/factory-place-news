defmodule Factoryplace.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :url, :string
      add :comment, :text

      timestamps(type: :utc_datetime)
    end
  end
end
