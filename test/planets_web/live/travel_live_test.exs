defmodule PlanetsWeb.TravelLiveTest do
  use PlanetsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the initial empty page", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/")

    assert html =~ "No steps yet"
    assert html =~ "Total Fuel Required:"
  end

  test "calculates total fuel for single action", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    view |> element("button", "Earth") |> render_click()
    view |> element("button", "Launch") |> render_click()

    html =
      view
      |> form("form", ship: %{mass: "28801"})
      |> render_change()

    assert html =~ "Total Fuel Required: 19772"
  end

  test "calculates total fuel for the mission", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    view |> element("button", "Earth") |> render_click()
    view |> element("button", "Launch") |> render_click()

    view |> element("button", "Moon") |> render_click()
    view |> element("button", "Land") |> render_click()

    view |> element("button", "Launch") |> render_click()

    view |> element("button", "Earth") |> render_click()
    view |> element("button", "Land") |> render_click()

    html =
      view
      |> form("form", ship: %{mass: "28801"})
      |> render_change()

    assert html =~ "Total Fuel Required: 51898"
  end

  test "shows a validation error on invalid mass", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    view |> element("button", "Earth") |> render_click()
    view |> element("button", "Launch") |> render_click()

    html =
      view
      |> form("form", ship: %{mass: "-5"})
      |> render_change()

    assert html =~ "must be greater than 0"
  end
end
