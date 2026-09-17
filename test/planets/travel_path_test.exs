defmodule Planets.TravelPathTest do
  use ExUnit.Case, async: true

  alias Planets.TravelPath

  describe "landed?/1" do
    test "returns true for an empty travel path", do: assert(TravelPath.landed?([]))

    test "returns true when the last action was `land`",
      do: assert(TravelPath.landed?([{:launch, :earth}, {:land, :moon}]))

    test "returns false when the last action was `launch`",
      do: refute(TravelPath.landed?([{:launch, :earth}]))
  end

  describe "launch/2" do
    test "adds `launch destination` when travel path is empty" do
      assert TravelPath.launch([], :earth) == [{:launch, :earth}]
    end

    test "adds `launch destination` when is landed on that planet" do
      path = [{:launch, :earth}, {:land, :moon}]

      assert TravelPath.launch(path, :moon) == [
               {:launch, :earth},
               {:land, :moon},
               {:launch, :moon}
             ]
    end

    test "does not add `launch destination` when is not landed" do
      path = [{:launch, :earth}]

      assert TravelPath.launch(path, :moon) == path
    end

    test "does not add `launch destination` when is not landed on that planet" do
      path = [{:launch, :earth}, {:land, :moon}]

      assert TravelPath.launch(path, :mars) == path
    end
  end

  describe "land/2" do
    test "does not add `land destination` when travel path is empty" do
      path = []
      assert TravelPath.land(path, :earth) == path
    end

    test "adds `land destination` when is not landed" do
      path = [{:launch, :earth}]
      assert TravelPath.land(path, :moon) == [{:launch, :earth}, {:land, :moon}]
    end

    test "does not add `land destination` when is landed" do
      path = [{:land, :earth}]

      assert TravelPath.land(path, :moon) == path
    end
  end

  describe "remove_last/1" do
    test "returns travel path without the last action" do
      path = [{:launch, :earth}, {:land, :moon}]
      assert TravelPath.remove_last(path) == [{:launch, :earth}]
    end

    test "returns empty travel path when removing from empty travel path" do
      assert TravelPath.remove_last([]) == []
    end
  end

  describe "current_planet/1" do
    test "returns nil for an empty travel path", do: assert(TravelPath.current_planet([]) == nil)

    test "returns nil when the last action was `launch`",
      do: assert(TravelPath.current_planet([{:launch, :earth}]) == nil)

    test "returns the planet when the last action was `land`" do
      path = [{:launch, :earth}, {:land, :mars}]
      assert TravelPath.current_planet(path) == :mars
    end
  end

  test "destinations/0 returns all supported destination planets/objects" do
    assert TravelPath.destinations() == [:earth, :moon, :mars]
  end
end
