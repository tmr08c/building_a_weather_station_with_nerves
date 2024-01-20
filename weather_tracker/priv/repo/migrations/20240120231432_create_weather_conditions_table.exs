defmodule WeatherTracker.Repo.Migrations.CreateWeatherConditionsTable do
  use Ecto.Migration

  import Timescale.Migration

  def up do
    create table(:weather_conditions, primary_key: false) do
      add :timestamp, :naive_datetime, null: false
      add :altitude_m, :decimal, null: false
      add :pressure_pa, :decimal, null: false
      add :temperature_c, :decimal, null: false
      add :co2_eq_ppm, :decimal, null: false
      add :tvoc_ppb, :decimal, null: false
      add :light_lumens, :decimal, null: false
    end

    create_hypertable(:weather_conditions, :timestamp)
  end

  def down do
    drop table(:weather_conditions)
  end
end
