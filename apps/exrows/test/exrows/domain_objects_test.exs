alias Exrows.DomainObjects, as: DO

defmodule Exrows.DomainObjectsTest do
  use ExUnit.Case, async: true
  doctest DO.UserAggregate.Data.SystemsValueObject
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

  test "To build a Systems Value Object" do
    alias DO.UserAggregate.Data.SystemsValueObject
    alias DO.UserAggregate.Data.SystemSheeth
    id = 1
    d = SystemsValueObject.new(id)
    all = [%{id: :hello}, %{id: :world}, %{id: Kay}]
    act = [%{id: :hello}, %{id: Kay}]
    :ok = SystemsValueObject.put(d, all, act, :hello)
    assert [
      {me,
       % SystemSheeth{
         key: :hello,
         next_one: :world, next_active_one: Kay,
         previous_one: nil, previous_active_one: nil
       }}] = Registry.lookup(d.dict, :hello)
    assert me == self()
    assert [
      {me,
       % SystemSheeth{
         key: :world,
         next_one: Kay, next_active_one: nil,
         previous_one: :hello, previous_active_one: nil
       }}] = Registry.lookup(d.dict, :world)
    assert me == self()
    assert [
      {me,
       % SystemSheeth{
         key: Kay,
         next_one: nil, next_active_one: nil,
         previous_one: :world, previous_active_one: :hello
       }}] = Registry.lookup(d.dict, Kay)
    assert me == self()
  end
end
