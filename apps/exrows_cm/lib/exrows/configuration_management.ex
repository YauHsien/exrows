defmodule Exrows.ConfigurationManagement do
  @moduledoc """
  Documentation for `Exrows.ConfigurationManagement`.
  """

  def load_from_file(file) do
    :fast_yaml.decode_from_file(file)
  end
end
