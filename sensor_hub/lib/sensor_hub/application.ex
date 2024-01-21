defmodule SensorHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias SensorHub.Sensor

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SensorHub.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: SensorHub.Worker.start_link(arg)
        # {SensorHub.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: SensorHub.Worker.start_link(arg)
      # {SensorHub.Worker, arg},
    ]
  end

  # Children for all targets except host
  def children(_target) do
    [
      {SGP40, [name: SGP40]},
      {BMP280, [i2c_address: 0x77, name: BMP280]},
      {VEML6030, %{}},
      {Publisher, %{sensors: sensors(), weather_tracker_url: weather_tracker_url()}}
    ]
  end

  defp sensors() do
    Enum.map([SGP40, BMP280, VEML6030], &Sensor.new/1)
  end

  defp weather_tracker_url() do
    Application.fetch_env!(:sensor_hub, :weather_tracker_url)
  end

  def target() do
    Application.get_env(:sensor_hub, :target)
  end
end
