defmodule Exrows.DomainObjects.SystemAggregate.NodeEntity do
	use TypedStruct
  @type id :: integer
  @type ip :: IP.addr
  typedstruct do
    field :id, id
    field :ip, ip
  end
end
