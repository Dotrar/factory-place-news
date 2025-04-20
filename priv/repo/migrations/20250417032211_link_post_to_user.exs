defmodule Factoryplace.Repo.Migrations.LinkPostToUser do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    alter table(:comments) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:posts, [:user_id])
    create index(:comments, [:user_id])
  end
end
