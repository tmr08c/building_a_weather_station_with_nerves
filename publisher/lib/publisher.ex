defmodule Publisher do
  use GenServer

  require Logger

  def start_link(options \\ %{}) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(options) do
    state = %{
      interval: options[:interval] || 10_000,
      weather_tracker_url: options[:weather_tracker_url],
      sensors: options[:sensors],
      measurements: :no_measurements
    }

    schedule_next_publish(state.interval)
    {:ok, state}
  end

  defp schedule_next_publish(interval) do
    Process.send_after(self(), :publish_data, interval)
  end

  @impl true
  def handle_info(:publish_data, state) do
    {:noreply, state |> measure() |> publish()}
  end

  defp measure(state) do
    measurements =
      Enum.reduce(state.sensors, %{}, fn sensor, acc ->
        sensor_data = sensor.read.() |> sensor.convert.() |> dbg()
        Map.merge(acc, sensor_data)
      end)

    %{state | measurements: measurements}
  end

  defp publish(state) do
    Logger.debug("Attempting to send the following measurements: #{inspect(state.measurements)}")

    result = Req.post(state.weather_tracker_url, json: state.measurements)

    Logger.debug("Server response #{inspect(result)}")

    schedule_next_publish(state.interval)

    state
  end
end
