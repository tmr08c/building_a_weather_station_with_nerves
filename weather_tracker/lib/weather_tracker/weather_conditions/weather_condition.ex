defmodule WeatherTracker.WeatherConditions.WeatherCondition do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_fields ~w(
    altitude_m
    dew_point_c
    gas_resistance_ohms
    humidity_rh
    light_lumens
    pressure_pa
    temperature_c
    voc_index
  )a

  @derive {Jason.Encoder, only: @allowed_fields}
  @primary_key false

  schema "weather_conditions" do
    # This is a hypertable, so the timestamp is the primary key
    field :timestamp, :naive_datetime

    field :altitude_m, :decimal
    field :dew_point_c, :decimal
    field :gas_resistance_ohms, :decimal
    field :humidity_rh, :decimal
    field :light_lumens, :decimal
    field :pressure_pa, :decimal
    field :temperature_c, :decimal
    # This comes in as an integer, but going to make it a decimal to match
    # everything else
    field :voc_index, :decimal
  end

  def create_changeset(weather_conditions = %__MODULE__{}, attrs) do
    weather_conditions
    |> cast(attrs, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> put_change(:timestamp, NaiveDateTime.utc_now(:second))
  end
end
