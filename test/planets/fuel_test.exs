defmodule Planets.FuelTest do
  use ExUnit.Case, async: true

  alias Planets.Fuel

  describe "calculate/2" do
    test "calculates total fuel for single action considering all extra fuel" do
      travel_path = [{:land, :earth}]
      assert Fuel.calculate(travel_path, 28801) == 13447
    end

    test "calculates total fuel for the whole mission" do
      travel_path = [
        {:launch, :earth},
        {:land, :moon},
        {:launch, :moon},
        {:land, :mars},
        {:launch, :mars},
        {:land, :earth}
      ]

      assert Fuel.calculate(travel_path, 75432) == 212_161
    end

    test "returns 0 for small mass" do
      travel_path = [{:land, :earth}]
      assert Fuel.calculate(travel_path, 40) == 0
    end

    test "returns formula fuel amount when no extra fuel needed" do
      travel_path = [{:land, :earth}]
      assert Fuel.calculate(travel_path, 254) == 40
    end
  end
end
