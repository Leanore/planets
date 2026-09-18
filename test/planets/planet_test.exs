defmodule Planets.PlanetTest do
  use ExUnit.Case, async: true

  alias Planets.Planet

  describe "all/0" do
    test "returns the three supported planets" do
      assert Planet.all() == [:earth, :moon, :mars]
    end
  end

  describe "gravity/1" do
    test "returns gravity of Earth", do: assert(Planet.gravity(:earth) == 9.807)
    test "returns gravity of Moon", do: assert(Planet.gravity(:moon) == 1.62)
    test "returns gravity of Mars", do: assert(Planet.gravity(:mars) == 3.711)

    test "raises exception for a planet that is not supported" do
      assert_raise KeyError, fn -> Planet.gravity(:pluto) end
    end
  end
end
