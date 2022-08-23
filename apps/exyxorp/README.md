# Exrows.Exyxorp
. . . for reversal proxy in multiple nodes system.

## Introduction
This module is built upon `Phoenix.PubSub`.

At least two functions as followings are supported:

- To send command.
- To query services and get results.

## Exposed interfaces

The module `Exrows.Exyxorp` exposes three interfaces as followings.

To send a command in Round-Robin way,

```
@spec send_rr(cmd :: QueryStatement.t, node_base :: [Channel.t], tries :: integer)
:: {:ok, nodes_consumed :: Channel.t, errors :: [{Channel.t, term}]}
|  {:error, :timeout, nodes_consumed :: [Channel.t]}
|  {:error, reasons :: [{Channel.t, term}]}
```

To query results from some service in Round-Robin way,

```
  @spec find_rr(query :: QueryStatement.t, node_base :: [Channel.t], tries :: integer)
  :: {:ok, results :: [term], nodes_consumed :: Channel.t, errors :: [{Channel.t, term}]}
  |  {:error, :timeout, nodes_consumed :: [Channel.t]}
  |  {:error, reasons :: [{Channel.t, term}]}
```

To query results from all nodes with some service,

```
@spec find_bc(query :: QueryStatement.t, node_base :: [Channel.t])
:: {:ok, results :: [term]}
|  {:error, :timeout}
|  {:error, reasons :: [term]}
```

## Usage

1. Provide a channel list: the channel list contains one or more `:phoenix_pubsub` attributes such as server name and topic.
1. Prepare a command or a query.
1. Determine how many tries you want.
1. Invoke one of `Exrows.Exyxorp.send_rr/3`, `Exrows.Exyxorp.find_rr/3`, `Exrows.Exyxorp.find_bc/2` with above arguments.
1. Learn the result of invocation.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exyxorp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exyxorp, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/exyxorp>.

