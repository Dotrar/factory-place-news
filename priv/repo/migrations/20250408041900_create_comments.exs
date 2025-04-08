defmodule Factoryplace.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :depth, :integer
      add :parent_id, references(:comments, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:parent_id])
    create index(:comments, [:post_id])
  end
end
