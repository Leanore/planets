defmodule Planets.Planet do
  @type t :: :earth | :moon | :mars

  @gravity %{earth: 9.807, moon: 1.62, mars: 3.711}

  @spec all() :: [t()]
  def all, do: Map.keys(@gravity)

  @spec gravity(t()) :: float()
  def gravity(planet), do: Map.fetch!(@gravity, planet)
end
