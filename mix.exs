defmodule Phoenix.DashboardClock.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :phoenix_dashboard_clock,
      version: @version,
      elixir: "~> 1.7",
      compilers: [:phoenix] ++ Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      mod: {Phoenix.DashboardClock.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_live_dashboard, phoenix_live_dashboard_opts()},
      {:phoenix_live_view, "~> 0.8.0", github: "phoenixframework/phoenix_live_view"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:plug_cowboy, "~> 2.0", only: :dev},
      {:jason, "~> 1.0", only: [:dev, :test]},
      {:floki, "~> 0.24.0", only: :test},
      {:ex_doc, "~> 0.21", only: :docs}
    ]
  end

  defp aliases() do
    [
      setup: ["deps.get", &setup_npm/1]
    ]
  end

  defp phoenix_live_dashboard_opts do
    if path = System.get_env("PHX_DASHBOARD_PATH") do
      [path: path]
    else
      [github: "wojtekmach/phoenix_live_dashboard", branch: "wm-components"]
    end
  end

  defp setup_npm(_) do
    cmd("cd assets && npm install")
  end

  defp cmd(command, opts \\ []) do
    result = Mix.shell().cmd(command, opts)

    if result != 0 do
      Mix.raise("Non-zero result (#{result}) from: #{command}")
    end
  end
end
