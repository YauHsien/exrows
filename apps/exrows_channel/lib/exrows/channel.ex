defmodule Exrows.Channel do
  use TypedStruct
  alias Phoenix.PubSub

  typedstruct do
    @typedoc "Phoenix.PubSub channel"
    field :node_name, PubSub.node_name
    field :server,    PubSub.t,        enforce: true
    field :topic,     PubSub.topic,    enforce: true
  end
end
