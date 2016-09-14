defmodule SmartThings do
	use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode

	# Public API

  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: "CLIENT_ID",
      client_secret: "CLIENT_SECRET",
      redirect_uri: "CALLBACK_URL",
      site: "https://graph.api.smartthings.com",
      authorize_url: "https://graph.api.smartthings.com/oauth/authorize",
      token_url: "https://graph.api.smartthings.com/oauth/token"
    ])
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), scope: "app")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), params)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("accept", "application/json")
    |> put_header("content-type", "application/x-www-form-urlencoded")
    |> put_param(:client_id, "CLIENT_ID")
    |> put_param(:client_secret, "CLIENT_SECRET")
    |> put_param(:grant_type, "authorization")
    |> AuthCode.get_token(params, headers)
  end
end