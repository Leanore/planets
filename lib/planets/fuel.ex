defmodule Planets.Fuel do
  alias Planets.Planet

  @coefficients %{launch: {0.042, 33}, land: {0.033, 42}}

  @spec calculate([{:launch | :land, Planet.t()}], number()) :: non_neg_integer()
  def calculate(travel_path, ship_mass) when is_number(ship_mass) and ship_mass >= 0 do
    {total_fuel, _total_mass} =
      travel_path
      |> Enum.reverse()
      |> Enum.reduce({0, ship_mass}, fn {action, planet}, {total_fuel, total_mass} ->
        fuel = calculate_fuel(total_mass, Planet.gravity(planet), action)
        {total_fuel + fuel, total_mass + fuel}
      end)

    total_fuel
  end

  defp calculate_fuel(mass, gravity, action) do
    case formula_fuel(mass, gravity, action) do
      fuel when fuel <= 0 -> 0
      fuel -> fuel + calculate_fuel(fuel, gravity, action)
    end
  end

  defp formula_fuel(mass, gravity, action) do
    {c1, c2} = @coefficients[action]
    floor(mass * gravity * c1 - c2)
  end
end
