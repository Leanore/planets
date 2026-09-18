defmodule Planets.ShipTest do
  use ExUnit.Case, async: true

  alias Planets.Ship

  describe "changeset/1" do
    test "valid with a positive integer mass" do
      assert Ship.changeset(%{"mass" => "28801"}).valid?
    end

    test "invalid without a mass" do
      refute Ship.changeset().valid?
    end

    test "invalid with a 0 mass" do
      refute Ship.changeset(%{"mass" => "0"}).valid?
    end

    test "invalid with a non-positive mass" do
      refute Ship.changeset(%{"mass" => "-10"}).valid?
    end

    test "invalid with a non-numeric mass" do
      refute Ship.changeset(%{"mass" => "text"}).valid?
    end
  end

  describe "mass/1" do
    test "returns the mass when valid" do
      assert Ship.mass(Ship.changeset(%{"mass" => "28801"})) == 28801
    end

    test "returns nil when invalid" do
      assert Ship.mass(Ship.changeset(%{"mass" => "0"})) == nil
    end
  end
end
