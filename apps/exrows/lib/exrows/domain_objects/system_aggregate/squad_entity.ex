defmodule Exrows.DomainObjects.SystemAggregate.SquadEntity do
  alias Exrows.DomainObjects.FeatureEntity
  alias Exrows.DomainObjects.SystemAggregate.SquadEntity
  alias Exrows.DomainObjects.SystemAggregate.NetEntity
	use TypedStruct
  @type id :: String.t
  typedstruct do
    field :id, id
    field :app, FeatureEntity.t
    field :type, :yxorp | :broadcast, enforce: true, default: :broadcast
    field :deps, [{SquadEntity.id, SquadEntity.t}]
    field :net, NetEntity.t
  end
end
