defmodule Factoryplace.Repo do
  use Ecto.Repo,
    otp_app: :factoryplace,
    adapter: Ecto.Adapters.Postgres
end
