defmodule WeatherTracker.Repo.Migrations.UpdateFieldsOnWeatherConditions do
  use Ecto.Migration

  def change do
    alter table(:weather_conditions) do
      remove :co2_eq_ppm, :decimal, null: false
      remove :tvoc_ppb, :decimal, null: false

      add :dew_point_c, :decimal, null: false
      add :gas_resistance_ohms, :decimal, null: false
      add :humidity_rh, :decimal, null: false
      # This comes in as an integer, but going to make it a decimal to match everything else
      add :voc_index, :decimal, null: false
    end
  end
end
