defmodule Planets.Ship do
  import Ecto.Changeset

  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(params \\ %{}) do
    {%{mass: nil}, %{mass: :integer}}
    |> cast(params, [:mass])
    |> validate_required([:mass])
    |> validate_number(:mass, greater_than: 0)
  end

  @spec mass(Ecto.Changeset.t()) :: pos_integer() | nil
  def mass(changeset) do
    if changeset.valid? do
      %{mass: mass} = apply_changes(changeset)
      mass
    end
  end
end
