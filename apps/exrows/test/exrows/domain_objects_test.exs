ExUnit.start()
defmodule Exrows.DomainObjectsTest do
  use ExUnit.Case, async: true
  alias Exrows.DomainObjects, as: DO
  alias Exrows.Schemata, as: Sk

  test "method usage" do
    t = %Sk.AuthToken { user_account_id: 2, value: "value" }
    u = %Sk.UserAccount {
      id: t.user_account_id,
      user_id: "user Id",
      salt: "salt",
      password: "encrypted password",
      auth_tokens: [t]
    }
    ps = GenServer.start_link(DO.UserAggregate, [user_account: u])
    assert {:ok, s} = ps
    require DO.UserAggregate.Methods, as: Method
    m = Method.getUserAccount()
    pr = GenServer.call(s, m)
    assert {:ok, r} = pr
    assert %DO.UserAggregate.Data.UserAccountEntity{} = r
    assert :ok = GenServer.stop(s, :normal)
  end
end
