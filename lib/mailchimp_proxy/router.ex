defmodule MailchimpProxy.Router do
  @moduledoc """
  HTTP Router for MailchimpProxy.

  """

  require Logger

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

  plug Corsica,
    origins: {__MODULE__, :allow_origin},
    allow_headers: ~w(content-type)


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
  # Public
  #####################################################

  @doc """
  Fetches allowed origins from the runtime environment.

  """
  @spec allow_origin(binary) :: boolean
  def allow_origin(orig) do
    case get_env_var(:allowed_origins) do
      nil ->
        false
      "*" ->
        true
      origins when is_binary(origins) ->
        orig in String.split(origins, ",")
    end
  end


  #####################################################
  # Private
  #####################################################

  @spec subscribe_to_list(binary, binary) :: :ok | {:error, reason :: any}
  defp subscribe_to_list(email, list_id \\ get_env_var(:mailchimp_list_id)) do
    base_url =
      "https://#{get_env_var(:mailchimp_data_center)}.api.mailchimp.com/3.0"

    url =
      "#{base_url}/lists/#{list_id}/members"

    body =
      Poison.encode!(%{email_address: email, status: :pending})

    headers =
      []

    options =
      [hackney: [basic_auth: {"_", get_env_var(:mailchimp_api_token)}]]

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

  defp get_env_var(var) do
    case Application.get_env(:mailchimp_proxy, var) do
      {:system, var_name} ->
        System.get_env(var_name)

      {:system, var_name, default} ->
        case System.get_env(var_name) do
          nil ->
            default

          val ->
            val
        end

      val ->
        val
    end
  end

end
