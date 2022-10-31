defmodule Exrows.DomainObjects.AuthenticationService do

  @doc """
  User authentication
    input:
      user Id
      plaintext password
    event:
      not available.
    output:
      user auth token
    note:
      token may be expired.
  """
  @spec auth(user_Id :: String.t, plaintext_password :: String.t) :: utoken :: String.t
  def auth(user_Id, plaintext_password) do
    # TODO: exchange user Id and password to token.
    utoken = "NEED to change"
  end

  @doc """
  User authentication
    input:
      user auth token
    event:
      not available.
    output:
      user auth token (maybe the same or another)
    note:
      this function may return the same token.
      token may be expired.
  """
  @spec auth(utoken :: String.t) :: utoken_1 :: String.t
  def auth(utoken) do
    # TODO: verify user token.
    utoken
  end

  @doc """
  De-authentication
    input:
      user auth token
    event:
      not available.
    output:
      :ok
  """
  def discard(utoken) do
    # TODO: discard user token
    :ok
  end
end
