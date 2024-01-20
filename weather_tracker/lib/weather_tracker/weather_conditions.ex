defmodule WeatherTracker.WeatherConditions do
  alias WeatherTracker.Repo
  alias WeatherTracker.WeatherConditions.WeatherCondition

  def create_entry(attrs) do
    %WeatherCondition{} |> WeatherCondition.create_changeset(attrs) |> Repo.insert()
  end
end
