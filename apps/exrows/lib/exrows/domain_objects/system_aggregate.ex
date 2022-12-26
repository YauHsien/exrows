alias Exrows.DomainObjects, as: DO
alias DO.SystemAggregate
defmodule SystemAggregate do
  alias SystemAggregate.NetEntity
  alias SystemAggregate.SquadEntity
	use TypedStruct
  typedstruct do
    field :conf_file, String.t
    field :activated, boolean
    field :nets, [{NetEntity.id, NetEntity.t}]
    field :squads, [{SquadEntity.id, SquadEntity.t}]
  end
end
