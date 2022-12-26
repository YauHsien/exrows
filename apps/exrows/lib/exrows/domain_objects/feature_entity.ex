defmodule Exrows.DomainObjects.FeatureEntity do
	use TypedStruct
  @type id :: String.t
  typedstruct do
    field :id, id
    field :deps, [String.t] # List of another feature Id
    field :exports, [{String.t, port}] # Type Keyword.t
  end
end
