defmodule Exrows.Exyxorp.Action.Base do
  alias Exrows.Channel
  alias Exrows.QueryStatement
  alias Phoenix.PubSub

  @wait_ms 2000

  @spec query(statement :: QueryStatement.t, channel :: Channel.t)
  :: {:ok, results :: [term]}
  |  {:error, :timeout}
  |  {:error, reason :: term}
  def query(statement, channel, wait_ms \\ @wait_ms)

  def query(statement, {server, topic}, wait_ms) do
    case PubSub.broadcast(server, topic, statement) do
      {:error, term} ->
        {:error, term}
      :ok ->
        receive do
          {:ok, terms} ->
            {:ok, terms}
	        {:error, reason} ->
		        {:error, reason}
        after
          wait_ms ->
            {:error, :timeout}
        end
    end
  end

  def query(statement, {node_name, server, topic}, wait_ms) do
    case PubSub.direct_broadcast(node_name, server, topic, statement) do
      {:error, term} ->
        {:error, term}
      :ok ->
        receive do
          {:ok, terms} ->
            {:ok, terms}
          {:error, reason} ->
            {:error, reason}
        after
          wait_ms ->
             {:error, :timeout}
        end
    end
  end
end
