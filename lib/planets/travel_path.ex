defmodule Planets.TravelPath do
  alias Planets.Planet

  def destinations, do: Planet.all()

  def landed?([]), do: true
  def landed?(path), do: match?({:land, _}, List.last(path))

  def launch(path, destination) do
    cond do
      path == [] -> path ++ [{:launch, destination}]
      landed?(path) and current_planet(path) == destination -> path ++ [{:launch, destination}]
      true -> path
    end
  end

  def land(path, destination) do
    if landed?(path), do: path, else: path ++ [{:land, destination}]
  end

  def remove_last(path), do: List.delete_at(path, -1)

  def current_planet(path) do
    case List.last(path) do
      {:land, planet} -> planet
      _ -> nil
    end
  end
end
