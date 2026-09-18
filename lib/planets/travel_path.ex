defmodule Planets.TravelPath do
  alias Planets.Planet

  @type action :: :launch | :land
  @type step :: {action(), Planet.t()}
  @type t :: [step()]

  @spec destinations() :: [Planet.t()]
  def destinations, do: Planet.all()

  @spec landed?(t()) :: boolean()
  def landed?([]), do: true
  def landed?(path), do: match?({:land, _}, List.last(path))

  @spec launch(t(), Planet.t()) :: t()
  def launch(path, destination) do
    cond do
      path == [] -> path ++ [{:launch, destination}]
      landed?(path) and current_planet(path) == destination -> path ++ [{:launch, destination}]
      true -> path
    end
  end

  @spec land(t(), Planet.t()) :: t()
  def land(path, destination) do
    if landed?(path), do: path, else: path ++ [{:land, destination}]
  end

  @spec remove_last(t()) :: t()
  def remove_last(path), do: List.delete_at(path, -1)

  @spec current_planet(t()) :: Planet.t() | nil
  def current_planet(path) do
    case List.last(path) do
      {:land, planet} -> planet
      _ -> nil
    end
  end
end
