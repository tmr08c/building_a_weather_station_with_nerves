defmodule VEML6030 do
  use GenServer

  require Logger

  alias VEML6030.Comm
  alias VEML6030.Config

  def start_link(options \\ %{}) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  def get_measurement do
    GenServer.call(__MODULE__, :get_measurement)
  end

  @impl true
  def init(%{address: address, i2c_bus_name: bus_name} = args) do
    i2c = Comm.open(bus_name)

    config = args |> Map.take([:gain, :int_time, :shutdown, :intterupt]) |> Config.new()

    Comm.write_config(config, i2c, address)
    :timer.send_interval(1_000, :measure)

    state = %{
      i2c: i2c,
      address: address,
      config: config,
      last_reading: :no_reading
    }

    {:ok, state}
  end

  # If we aren't given an address, we will attempt to disover based on known,
  # commonly ussed addresses
  def init(args) do
    {bus_name, address} = Comm.discover()
    transport = "bus: #{bus_name}, address: #{address}"

    Logger.info("Starting VEML6030. Please specify and address and a bus.")
    Logger.info("Starting on " <> transport)

    args |> Map.put(:address, address) |> Map.put(:i2c_bus_name, bus_name) |> init()
  end

  @impl true
  def handle_info(:measure, state) do
    %{i2c: i2c, address: address, config: config} = state
    {:noreply, %{state | last_reading: Comm.read(i2c, address, config)}}
  end

  @impl true
  def handle_call(:get_measurement, _from, state) do
    {:reply, state.last_reading, state}
  end
end
