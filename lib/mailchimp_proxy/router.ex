defmodule MailchimpProxy.Router do
  @moduledoc """
  HTTP Router for MailchimpProxy.

  """

  require Logger

  #####################################################
  # Annotations
  #####################################################

  @mc_default_subscriber_list Application.get_env(:mailchimp_proxy, :default_subscriber_list)
  @mc_data_center Application.get_env(:mailchimp_proxy, :mailchimp_data_center)
  @mc_base_url "https://#{@mc_data_center}.api.mailchimp.com/3.0"
  @mc_api_token Application.get_env(:mailchimp_proxy, :mailchimp_api_token)


  #####################################################
  # Plugs
  #####################################################

  use Plug.Router

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug :match

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison

  plug CORSPlug,
    origin: Application.get_env(:mailchimp_proxy, :allowed_origins)

  plug :dispatch


  #####################################################
  # Routes
  #####################################################

  post "/subscribers/" do
    %{"email" => email} =
      conn.body_params

    with true <- valid_email?(email),
      :ok <- subscribe_to_list(email) do

      send_resp(conn, 200, Poison.encode!(%{message: "Success"}))
    else
      false ->
        send_resp(conn, 400, Poison.encode!(%{message: "Invalid email address: #{email}"}))

      {:error, reason} ->
        send_resp(conn, 500, Poison.encode!(%{message: reason}))
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end


  #####################################################
  # Private
  #####################################################

  @spec subscribe_to_list(binary, binary) :: :ok | {:error, reason :: any}
  defp subscribe_to_list(email, list_id \\ @mc_default_subscriber_list) do
    url =
      "#{@mc_base_url}/lists/#{list_id}/members"

    body =
      Poison.encode!(%{email_address: email, status: :pending})

    headers =
      []

    options =
      [hackney: [basic_auth: {"_", @mc_api_token}]]

    case HTTPoison.post(url, body, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        :ok

      {:ok, %HTTPoison.Response{} = res} ->
        Logger.error "Error creating new subscription: #{inspect res}"
        {:error, "There was an error. Please try again later."}
    end
  end


  @email_regex ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/

  @spec valid_email?(binary) :: boolean
  defp valid_email?(email) do
    email =~ @email_regex
  end
end
