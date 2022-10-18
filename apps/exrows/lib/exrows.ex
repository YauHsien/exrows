defmodule Exrows do
  @moduledoc """
  Exrows keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def build_registry(name) do
    {:ok, reg} = Registry.start_link(keys: :unique, name: name)
    reg
  end
end
