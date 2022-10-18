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
      user_account: Data.UserAccountEntity.build(user_account),
      systems: SystemsValueObject.new(user_account.id)
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

defmodule Data.SystemSheeth do
  use TypedStruct
  typedstruct do
    field :key, :any
    field :data, :any
    field :previous_one, t
    field :previous_active_one, t
    field :next_one, t
    field :next_active_one, t
  end
end

defmodule Data.SystemsValueObject do
  use TypedStruct

	typedstruct do
    field :dict, atom()
    field :current, Data.SystemSheeth.t
  end

  @spec new(term()) :: t
  def new(id) do
    name = :'#{Data.SystemsValueObject.Registry}.Id#{inspect id}'
    Exrows.build_registry(name)
    % Data.SystemsValueObject { dict: name }
  end

  @spec put(t, all_list :: [Data.SystemSheeth.t], activation_list :: [Data.SystemSheeth.t], current :: Data.SystemSheeth.t) :: :ok
  @doc """
  """
  def put(self, all_list, activation_list, current) do
    suture(all_list)
    |> Enum.map(& Registry.register(self.dict, &1.key, &1) )
    suture(activation_list)
    |> Enum.map(& Registry.update_value(self.dict, &1.key, copy_act_state(&1)) )
    % Data.SystemsValueObject { self | current: current }
    :ok
  end

  @doc """
  . . . to stitch up a list.

  Example
  -------

  iex> alias Exrows.DomainObjects.UserAggregate.Data, as: Data
  ...> [ % Data.SystemSheeth { next_one: :world, previous_one: nil },
  ...>   % Data.SystemSheeth { next_one: Kay, previous_one: :hello },
  ...>   % Data.SystemSheeth { next_one: nil, previous_one: :world }
  ...> ] = Data.SystemsValueObject.suture([%{:id => :hello}, %{:id => :world}, %{:id => Kay}])
  [
    % Exrows.DomainObjects.UserAggregate.Data.SystemSheeth {
      next_active_one: nil,     next_one: :world,
      previous_active_one: nil, previous_one: nil,
      data: %{id: :hello},      key: :hello
    },
    % Exrows.DomainObjects.UserAggregate.Data.SystemSheeth {
      next_active_one: nil,     next_one: Kay,
      previous_active_one: nil, previous_one: :hello,
      data: %{id: :world},      key: :world
    },
    % Exrows.DomainObjects.UserAggregate.Data.SystemSheeth {
      next_active_one: nil,     next_one: nil,
      previous_active_one: nil, previous_one: :world,
      data: %{id: Kay},         key: Kay
    }
  ]
  """
  def suture(list) do
    Enum.reverse(list)
    |> Enum.map(fn a -> % Data.SystemSheeth { key: a.id, data: a } end)
    |> Enum.reduce(&suture/2)
  end

  defp suture(head, tail)
  defp suture(a, [b|acc]) do
    [
      % Data.SystemSheeth { a | next_one: b.key },
      % Data.SystemSheeth { b | previous_one: a.key }
      | acc
    ]
  end
  defp suture(a, b) do
    [
      % Data.SystemSheeth { a | next_one: b.key },
      % Data.SystemSheeth { b | previous_one: a.key }
    ]
  end

  @spec copy_act_state(entity :: Data.SystemSheeth.t) :: update_fn :: (Data.SystemSheeth.t -> Data.SystemSheeth.t)
  defp copy_act_state(entity) do
    fn entity0 ->
      % Data.SystemSheeth
      { entity0 |
        # Do magic copy.
        next_active_one: entity.next_one,
        previous_active_one: entity.previous_one
      }
    end
  end
end
