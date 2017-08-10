defmodule MailchimpProxy.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mailchimp_proxy,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MailchimpProxy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cortex, "~> 0.2", only: [:dev, :test]},
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.3"},
      {:poison, "~> 3.1"},
      {:corsica, "~> 1.0"},
      {:httpoison, "~> 0.11.2"},
      {:distillery, "~> 1.4", runtime: false},
    ]
  end
end
