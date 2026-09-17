defmodule Planets.Ship do
  import Ecto.Changeset

  def changeset(params \\ %{}) do
    {%{mass: nil}, %{mass: :integer}}
    |> cast(params, [:mass])
    |> validate_required([:mass])
    |> validate_number(:mass, greater_than: 0)
  end

  def mass(changeset) do
    if changeset.valid? do
      %{mass: mass} = apply_changes(changeset)
      mass
    end
  end
end
