defmodule Exrows.Exyxorp.RoundRobin.Send do
  Module.register_attribute(__MODULE__, :moduledoc, persist: true)

  @moduledoc """
  To send a command by Round-Robin.
  """

  @wait_ms 2000

  alias Exrows.Channel
  alias Exrows.Exyxorp.Action
  alias Exrows.QueryStatement

  @spec approach(cmd :: QueryStatement, node_base :: [Channel.t], tries :: integer)
  :: {:ok, nodes_consumed :: Channel.t, errors :: [{Channel.t, term}]}
  |  {:error, :timeout, nodes_consumed :: [Channel.t]}
  |  {:error, reasons :: [{Channel.t, term}]}

  @spec approach(cmd :: QueryStatement, node_base :: [Channel.t], tries :: integer, wait_ms :: integer)
  :: {:ok, nodes_consumed :: Channel.t, errors :: [{Channel.t, term}]}
  |  {:error, :timeout, nodes_consumed :: [Channel.t]}
  |  {:error, reasons :: [{Channel.t, term}]}

  def approach(cmd, node_base, tries, wait_ms \\ @wait_ms)

  def approach(_, [], _, _),
    do: {:ok, [], []}

  def approach(cmd, node_base, tries, wait_ms) when length(node_base) < tries,
    do: approach(cmd, node_base ++ node_base, tries, wait_ms)

  def approach(cmd, node_base, tries, wait_ms) when tries > 0,
    do: approach(cmd, node_base, [], tries, wait_ms)

  def approach(_, _, 0, _),
    do: {:ok, [], []}

  # Initial state:
  # - node_base \= []
  # - errors = []
  # - tries > 0
  # End state:
  # - tries = 0
  defp approach(cmd, node_base, errors, tries, wait_ms)

  defp approach(cmd, [channel|node_base], errors, tries, wait_ms) when tries > 0 do
    case Action.Base.query(cmd, channel) do
      {:ok, _} ->
        {:ok, channel, errors}
      {:error, reason} ->
        approach(cmd, node_base, [{channel,reason}|errors], tries-1, wait_ms)
    end
  end

  defp approach(_, _, errors, 0, _),
    do: return(errors)

  @spec return([{Channel.t, term}])
  :: {:error, :timeout, nodes_consumed :: [Channel.t]}
  |  {:error, reasons :: [{Channel.t, term}]}
  defp return(errors) do
    reasons =
      errors
      |> Enum.map(& elem(&1,1))
      |> Enum.uniq
    case reasons do
      [:timeout] ->
        {:error, :timeout, errors |> Enum.map(& elem(&1,0))}
      _ ->
        {:error, errors}
    end
  end
end
