defmodule Exrows.Repo do
  use Ecto.Repo,
    otp_app: :exrows,
    adapter: Ecto.Adapters.Postgres
end
