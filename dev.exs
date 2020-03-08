# iex -S mix run dev.exs

# Configures the endpoint
Application.put_env(:phoenix_live_dashboard, DemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Hu4qQN3iKzTV4fJxhorPQlA/osH9fAMtbtjVS58PFgfw3ja5Z18Q/WSNR9wP4OfW",
  live_view: [signing_salt: "hMegieSe"],
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  check_origin: false,
  pubsub: [name: Demo.PubSub, adapter: Phoenix.PubSub.PG2],
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "production",
      "--watch-stdin",
      cd: "assets"
    ]
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/phoenix/live_dashboard/(live|views)/.*(ex)$",
      ~r"lib/phoenix/live_dashboard/templates/.*(ex)$"
    ]
  ]
)

defmodule DemoWeb.Telemetry do
  import Telemetry.Metrics

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.endpoint.stop.duration",
        tags: [:method, :request_path],
        tag_values: &tag_method_and_request_path/1,
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:controller_action],
        tag_values: &tag_controller_action/1,
        unit: {:native, :millisecond}
      ),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end

  # Extracts labels like "GET /"
  defp tag_method_and_request_path(metadata) do
    Map.take(metadata.conn, [:method, :request_path])
  end

  # Extracts controller#action from route dispatch
  defp tag_controller_action(%{plug: plug, plug_opts: plug_opts}) when is_atom(plug_opts) do
    %{controller_action: "#{inspect(plug)}##{plug_opts}"}
  end

  defp tag_controller_action(%{plug: plug}) do
    %{controller_action: inspect(plug)}
  end
end

defmodule DemoWeb.Router do
  use Phoenix.Router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :fetch_flash
  end

  live_dashboard("/dashboard", metrics: DemoWeb.Telemetry)
end

defmodule DemoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :phoenix_live_dashboard

  socket "/live", Phoenix.LiveView.Socket
  socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket

  plug Phoenix.LiveReloader
  plug Phoenix.CodeReloader

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.Session,
    store: :cookie,
    key: "_live_view_key",
    signing_salt: "/VEDsdfsffMnp5"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug DemoWeb.Router
end

Application.put_env(:phoenix, :serve_endpoints, true)

Task.start(fn ->
  children = [DemoWeb.Endpoint]
  {:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)
  Process.sleep(:infinity)
end)
