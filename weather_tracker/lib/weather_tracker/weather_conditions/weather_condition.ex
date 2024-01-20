defmodule WeatherTracker.WeatherConditions.WeatherCondition do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_fields ~w(altitude_m pressure_pa temperature_c co2_eq_ppm tvoc_ppb light_lumens)a

  @derive {Jason.Encoder, only: @allowed_fields}
  @primary_key false

  schema "weather_conditions" do
    field :timestamp, :naive_datetime
    field :altitude_m, :decimal
    field :pressure_pa, :decimal
    field :temperature_c, :decimal
    field :co2_eq_ppm, :decimal
    field :tvoc_ppb, :decimal
    field :light_lumens, :decimal
  end

  def create_changeset(weather_conditions = %__MODULE__{}, attrs) do
    weather_conditions
    |> cast(attrs, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> put_change(:timestamp, NaiveDateTime.utc_now(:second))
  end
end
