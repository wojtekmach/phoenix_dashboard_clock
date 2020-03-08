defmodule Phoenix.DashboardClock.ClockLive do
  use Phoenix.LiveDashboard.Web, :live_view

  @impl true
  def mount(params, session, socket) do
    :timer.send_interval(1000, :tick)
    socket = assign_defaults(socket, params, session)
    {:ok, assign(socket, now: now())}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= @now %>
    """
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, assign(socket, now: now())}
  end

  defp now() do
    NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
  end
end
