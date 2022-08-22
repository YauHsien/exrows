defmodule Exrows.QueryStatement do
  use TypedStruct
  alias Exrows.Channel

  typedstruct do
    @typedoc "Query statement"
    field :return_address, Channel.t, enforce: true
    field :payload,        term,      enforce: true
  end
end
