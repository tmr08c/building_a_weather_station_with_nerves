defmodule SensorHub.Sensor do
  @moduledoc """
  Provides a unified interface for reading data from various sensors.
  """

  defstruct [:name, :fields, :read, :convert]

  def new(name) do
    %__MODULE__{
      read: read_fn(name),
      convert: convert_fn(name),
      fields: fields(name),
      name: name
    }
  end

  def measure(sensor) do
    sensor.read.() |> sensor.convert.()
  end

  # This diverges from the book because I am ended up with a SGP40 and not an SGP30 like the book
  def fields(SGP40), do: [:voc_index]

  def fields(BMP280) do
    [
      :altitude_m,
      :pressure_pa,
      :temperature_c,

      # The book does not include these fields; I am going to try including them
      # since they are include, but I am unsure if they are useful
      :humidity_rh,
      :dew_point_c,
      :gas_resistance_ohms
    ]
  end

  def fields(VEML6030), do: [:light_lumens]

  def read_fn(SGP40), do: fn -> SGP40.measure(SGP40) end
  def read_fn(BMP280), do: fn -> BMP280.measure(BMP280) end
  def read_fn(VEML6030), do: fn -> VEML6030.get_measurement() end

  def convert_fn(SGP40) do
    fn reading ->
      case reading do
        {:ok, measurement} ->
          Map.take(measurement, fields(SGP40))

        _ ->
          # Maybe we could consider logging?
          %{}
      end
    end
  end

  def convert_fn(BMP280) do
    fn reading ->
      case reading do
        {:ok, measurement} ->
          Map.take(measurement, fields(BMP280))

        _ ->
          # Maybe we could consider logging?
          %{}
      end
    end
  end

  def convert_fn(VEML6030), do: &Enum.zip(fields(VEML6030), &1)
end
