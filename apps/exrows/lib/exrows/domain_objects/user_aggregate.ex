alias Exrows.DomainObjects, as: DO
alias DO.UserAggregate.Data, as: Data
alias DO.UserAggregate.Methods, as: Method
alias Exrows.Schemata, as: Sk

defmodule Method do
  defmacro getUserAccount() do
    quote do: {unquote(Method), :get_user_account}
  end
  defmacro getActivityHistory() do
    quote do: {unquote(Method), :get_activity_history}
  end
  defmacro getSystems() do
	  quote do: {unquote(Method), :get_systems}
  end
end

defmodule DO.UserAggregate do
  use GenServer
  require Method

	@impl true
  @spec init(keyword) :: {:ok, %{data: Data.t()}}
  def init(init_arg) do
    user_account =
      %Sk.UserAccount{} = init_arg |> Keyword.fetch!(:user_account)
    data =
      Data.build(user_account)
    {:ok, %{data: data}}
  end

  @impl true
  def handle_call(params, from, state)

  def handle_call(Method.getUserAccount(), _f, s) do
    {:reply, {:ok, s.data.user.user_account}, s}
  end

  def handle_call(Method.getActivityHistory(), _f, s) do
    {:reply, {:ok, s.data.user.activity_history}, s}
  end

  def handle_call(Method.getSystems(), _f, s) do
    {:reply, {:ok, s.data.user.systems}, s}
  end

  def handle_call(_p, _f, s) do
    {:noreply, s}
  end
end

defmodule Data do
  @moduledoc "Internal data structure of User Aggregate"
	use TypedStruct
  alias Data.UserEntity, as: UserEntity

  typedstruct do
    field :user, UserEntity.t, enforce: true
  end

  @spec build(Sk.UserAccount.t) :: t
  def build(%Sk.UserAccount{} = user_account) do
    %Data {
      user: Data.UserEntity.build(user_account)
    }
  end
end

defmodule Data.UserEntity do
  use TypedStruct
	alias Data.UserAccountEntity
  alias Data.ActivityHistoryValueObject
  alias Data.SystemsValueObject

  typedstruct do
    field :name, :string
    field :profile, :string
    field :user_account, UserAccountEntity.t
    field :activity_history, ActivityHistoryValueObject.t
    field :systems, SystemsValueObject.t
  end

  @spec build(Sk.UserAccount.t) :: t
  def build(%Sk.UserAccount{} = user_account) do
    %Data.UserEntity {
      name: user_account.name,
      profile: user_account.profile,
      user_account: Data.UserAccountEntity.build(user_account)
    }
  end
end

defmodule Data.UserAccountEntity do
  use TypedStruct

  typedstruct do
    field :user_id, :string
    field :salt, :string
    field :enc_password, :string
  end

  @spec build(Sk.UserAccount.t) :: t
  def build(%Sk.UserAccount{} = user_account) do
    %Data.UserAccountEntity {
      user_id: user_account.user_id,
      salt: user_account.salt,
      enc_password: user_account.password
    }
  end
end

defmodule Data.ActivityHistoryValueObject do
	use TypedStruct
  typedstruct do
    field :data, List.t
  end
end

defmodule Data.SystemsValueObject do
  use TypedStruct
	typedstruct do
    field :all, List.t
    field :activated, List.t
  end
end
