defmodule Exrows.DomainObjects.SystemAggregate.NetEntity do
  alias Exrows.DomainObjects.SystemAggregate.NodeEntity
	use TypedStruct
  @type id :: String.t
  @type external_ip :: IP.addr
  @type internal_ip :: IP.addr
  @type ip :: {external_ip, internal_ip} | internal_ip
  typedstruct do
    field :id, id
    field :description, String.t
    field :ip, ip
    field :nodes, [{NodeEntity.id, NodeEntity.t}]
  end
end
