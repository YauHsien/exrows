defmodule Exrows.Exyxorp do
  @moduledoc """
  Reversal proxy functions.
  """
  alias Exrows.Channel
  alias Exrows.Exyxorp.Broadcast
  alias Exrows.Exyxorp.RoundRobin
  alias Exrows.QueryStatement

  @spec send_rr(cmd :: QueryStatement.t, node_base :: [Channel.t], tries :: integer)
  :: {:ok, nodes_consumed :: Channel.t, errors :: [{Channel.t, term}]}
  |  {:error, :timeout, nodes_consumed :: [Channel.t]}
  |  {:error, reasons :: [{Channel.t, term}]}
  @doc RoundRobin.Send.__info__(:attributes)[:moduledoc] |> List.first |> elem(1)
  def send_rr(cmd, node_base, tries),
    do: RoundRobin.Send.approach(cmd, node_base, tries)

  @spec find_rr(query :: QueryStatement.t, node_base :: [Channel.t], tries :: integer)
  :: {:ok, results :: [term], nodes_consumed :: Channel.t, errors :: [{Channel.t, term}]}
  |  {:error, :timeout, nodes_consumed :: [Channel.t]}
  |  {:error, reasons :: [{Channel.t, term}]}
  @doc RoundRobin.Find.__info__(:attributes)[:moduledoc] |> List.first |> elem(1)
  def find_rr(query, node_base, tries),
    do: RoundRobin.Find.approach(query, node_base, tries)

  @spec find_bc(query :: QueryStatement.t, node_base :: [Channel.t])
  :: {:ok, results :: [term]}
  |  {:error, :timeout}
  |  {:error, reasons :: [term]}
  @doc Broadcast.Find.__info__(:attributes)[:moduledoc] |> List.first |> elem(1)
  def find_bc(query, node_base),
    do: Broadcast.Find.approach(query, node_base)
end
