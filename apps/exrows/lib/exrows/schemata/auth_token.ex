defmodule Exrows.Schemata.AuthToken do
  use Ecto.Schema

  schema "auth_tokens" do
    field :value, :string
    field :timestamp, :naive_datetime_usec, default: NaiveDateTime.utc_now()
    field :expire_ts, :naive_datetime_usec
    field :discard_ts, :naive_datetime_usec

    belongs_to :user_account, Exrows.Schemata.UserAccount
  end
end
