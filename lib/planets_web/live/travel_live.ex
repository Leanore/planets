defmodule PlanetsWeb.TravelLive do
  use PlanetsWeb, :live_view

  alias Planets.{Fuel, Ship, TravelPath}

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       path: [],
       selected: nil,
       mass_form: to_form(Ship.changeset(), as: :ship, id: "ship"),
       total_fuel: nil
     )}
  end

  def render(assigns) do
    assigns =
      assign(assigns, :already_landed, TravelPath.current_planet(assigns.path) != nil)

    ~H"""
    <Layouts.app flash={@flash}>
      <h1 class="text-2xl font-bold">Fuel Calculator</h1>

      <div class="flex gap-2">
        <.button
          :for={destination <- TravelPath.destinations()}
          phx-click="select"
          phx-value-destination={destination}
          variant={if @selected == destination, do: "primary"}
          disabled={@already_landed}
        >{label(destination)}</.button>
      </div>

      <div class="flex gap-2">
        <.button phx-click="launch" disabled={@selected == nil or not TravelPath.landed?(@path)}>Launch</.button>
        <.button phx-click="land" disabled={@selected == nil or TravelPath.landed?(@path)}>Land</.button>
      </div>

      <div class="flex flex-wrap items-center gap-3 py-4 min-h-12">
        <span :if={@path == []} class="text-lg opacity-60">No steps yet</span>
        <span :for={{action, destination} <- @path} class="badge badge-lg badge-primary text-base">
          {label(action)} {label(destination)}
        </span>
      </div>

      <div class="flex gap-2">
        <.button phx-click="remove_last">Remove Last</.button>
        <.button phx-click="clear">Clear Travel Path</.button>
      </div>

      <.form for={@mass_form} phx-change="validate" phx-submit="validate">
        <.input field={@mass_form[:mass]} type="number" label="Equipment mass (kg)" />
      </.form>

      <p class="text-lg font-semibold">Total Fuel Required: {@total_fuel}</p>
    </Layouts.app>
    """
  end

  def handle_event("select", %{"destination" => destination}, socket) do
    {:noreply, assign(socket, selected: to_destination(destination))}
  end

  def handle_event("launch", _params, %{assigns: %{selected: nil}} = socket) do
    {:noreply, socket}
  end

  def handle_event("launch", _params, socket) do
    path = TravelPath.launch(socket.assigns.path, socket.assigns.selected)
    {:noreply, socket |> assign(path: path, selected: nil) |> recalculate()}
  end

  def handle_event("land", _params, %{assigns: %{selected: nil}} = socket) do
    {:noreply, socket}
  end

  def handle_event("land", _params, socket) do
    path = TravelPath.land(socket.assigns.path, socket.assigns.selected)
    {:noreply, socket |> assign(path: path) |> recalculate()}
  end

  def handle_event("remove_last", _params, socket) do
    path = TravelPath.remove_last(socket.assigns.path)

    {:noreply,
     socket |> assign(path: path, selected: TravelPath.current_planet(path)) |> recalculate()}
  end

  def handle_event("clear", _params, socket) do
    {:noreply, socket |> assign(path: [], selected: nil) |> recalculate()}
  end

  def handle_event("validate", %{"ship" => params}, socket) do
    changeset = params |> Ship.changeset() |> Map.put(:action, :validate)

    {:noreply,
     socket |> assign(mass_form: to_form(changeset, as: :ship, id: "ship")) |> recalculate()}
  end

  defp to_destination(destination) do
    Enum.find(TravelPath.destinations(), &(Atom.to_string(&1) == destination))
  end

  defp label(atom), do: atom |> Atom.to_string() |> String.capitalize()

  defp recalculate(socket) do
    total_fuel =
      if mass = Ship.mass(socket.assigns.mass_form.source) do
        if socket.assigns.path != [], do: Fuel.calculate(socket.assigns.path, mass)
      end

    assign(socket, total_fuel: total_fuel)
  end
end
