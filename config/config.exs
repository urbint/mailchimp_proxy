# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :mailchimp_proxy, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:mailchimp_proxy, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#

allowed_origins =
  case System.get_env("ALLOWED_ORIGINS") do
    nil ->
      nil
    origins when is_binary(origins) ->
      origins |> String.split(",")
  end

config :mailchimp_proxy,
  allowed_origins: allowed_origins,
  mailchimp_data_center: System.get_env("MAILCHIMP_DATA_CENTER"),
  mailchimp_api_token: System.get_env("MAILCHIMP_API_TOKEN"),
  mailchimp_list_id: System.get_env("MAILCHIMP_LIST_ID")

if File.exists?(Path.join(__DIR__, "#{Mix.env}.exs")) do
  import_config "#{Mix.env}.exs"
end
