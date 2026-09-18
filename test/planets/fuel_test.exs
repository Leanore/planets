defmodule Planets.FuelTest do
  use ExUnit.Case, async: true

  alias Planets.Fuel

  describe "calculate/2" do
    test "calculates integer total fuel for single action considering all extra fuel" do
      travel_path = [{:land, :earth}]
      assert Fuel.calculate(travel_path, 28801) == 13447
    end

    test "calculates integer total fuel for a float mass" do
      assert Fuel.calculate([{:land, :earth}], 28803.5) == 13448
    end

    test "calculates total fuel for the Apollo 11 mission" do
      travel_path = [
        {:launch, :earth},
        {:land, :moon},
        {:launch, :moon},
        {:land, :earth}
      ]

      assert Fuel.calculate(travel_path, 28801) == 51898
    end

    test "calculates total fuel for the Mars mission" do
      travel_path = [
        {:launch, :earth},
        {:land, :mars},
        {:launch, :mars},
        {:land, :earth}
      ]

      assert Fuel.calculate(travel_path, 14606) == 33388
    end

    test "calculates total fuel for the Passenger Ship mission" do
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

    test "returns 0 for a zero mass" do
      assert Fuel.calculate([{:land, :earth}], 0) == 0
    end

    test "raises for a negative mass" do
      assert_raise FunctionClauseError, fn -> Fuel.calculate([{:land, :earth}], -1) end
    end
  end
end
