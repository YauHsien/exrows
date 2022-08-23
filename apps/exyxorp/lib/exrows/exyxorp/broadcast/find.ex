defmodule Exrows.Exyxorp.Broadcast.Find do
  Module.register_attribute(__MODULE__, :moduledoc, persist: true)

  @moduledoc """
  To query services by broadcast, then get results.
  """

  @wait_ms 2000

  alias Exrows.Channel
  alias Exrows.Exyxorp.Action
  alias Exrows.QueryStatement

  @spec approach(query :: QueryStatement.t, node_base :: [Channel.t])
  :: {:ok, results :: [term]}
  |  {:error, :timeout}
  |  {:error, reasons :: [term]}

  @spec approach(query :: QueryStatement.t, node_base :: [Channel.t], wait_ms :: integer)
  :: {:ok, results :: [term]}
  |  {:error, :timeout}
  |  {:error, reasons :: [term]}

  def approach(query, node_base, wait_ms \\ @wait_ms)

  def approach(_, [], _),
    do: {:ok, []}

  def approach(query, node_base, wait_ms) do
    node_base
    |> Enum.map(&(Action.Base.query(query, &1, wait_ms)))
    |> Enum.concat
    |> Enum.uniq
    |> return
  end

  defp return([{:error, :timeout}]),
    do: {:error, :timeout}

  defp return(things),
    do: return(things, [], [])

  defp return(things, results, errors)

  defp return([], [], errors) do
    errors
    |> Enum.uniq
    |> then(& {:error, &1})
  end

  defp return([], results, _),
    do: {:ok, results}

  defp return([{:ok,results0}|things], results, errors),
    do: return(things, [results0|results], errors)

  defp return([{:error,reason}|things], results, errors),
    do: return(things, results, [reason|errors])
end
