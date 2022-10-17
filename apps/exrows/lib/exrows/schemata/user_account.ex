defmodule Exrows.Schemata.UserAccount do
  use Ecto.Schema

  schema "user_accounts" do
    field :user_id, :string
    field :salt, :string
    field :password, :string
    field :timestamp, :naive_datetime_usec, default: NaiveDateTime.utc_now()
    field :name, :string
    field :profile, :string

    has_many :auth_tokens, Exrows.Schemata.AuthToken
  end
end
