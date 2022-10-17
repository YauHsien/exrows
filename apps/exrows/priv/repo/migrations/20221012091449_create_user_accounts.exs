defmodule Exrows.Repo.Migrations.CreateUserAccounts do
  use Ecto.Migration

  def change do

    create table(:user_accounts) do
      add :user_id, :string
      add :salt, :string
      add :password, :string
      add :timestamp, :naive_datetime_usec
      add :name, :string
      add :profile, :string
    end

    create table(:auth_tokens) do
      add :user_account_id, references(:user_accounts)
      add :value, :string
      add :timestamp, :naive_datetime_usec
      add :expire_ts, :naive_datetime_usec
      add :discard_ts, :naive_datetime_usec
    end
  end
end
