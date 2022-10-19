defmodule EventPlanningWeb.EventControllerTest do
  use EventPlanningWeb.ConnCase

  import EventPlanning.SchedulesFixtures

  @create_attrs %{
    active: 1,
    date_end: ~U[2022-10-05 09:47:00Z],
    date_start: ~U[2022-10-05 09:47:00Z],
    iteration: nil
  }
  @update_attrs %{
    active: 1,
    date_end: ~U[2022-10-06 09:47:00Z],
    date_start: ~U[2022-10-06 09:47:00Z],
    iteration: nil
  }
  @next_attrs %{
    active: 1,
    date_end: DateTime.add(DateTime.utc_now(), 1, :day),
    date_start: DateTime.add(DateTime.utc_now(), 1, :day),
    iteration: nil
  }
  @invalid_attrs %{active: nil, date_end: nil, date_start: nil, iteration: nil}

  describe "index" do
    test "lists default events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index))
      response = html_response(conn, 200)

      assert response =~ "my_schedule"
      assert response =~ "selected value=\"week\""
    end

    test "lists week events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index, view: "week"))
      response = html_response(conn, 200)

      assert response =~ "my_schedule"
      assert response =~ "selected value=\"week\""
    end

    test "lists month events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index, view: "month"))
      response = html_response(conn, 200)

      assert response =~ "my_schedule"
      assert response =~ "selected value=\"month\""
    end

    test "lists year events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index, view: "year"))
      response = html_response(conn, 200)

      assert response =~ "my_schedule"
      assert response =~ "selected value=\"year\""
    end

    test "lists all events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index, view: "all"))
      response = html_response(conn, 200)

      assert response =~ "my_schedule"
      assert response =~ "selected value=\"all\""
    end
  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :new))
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "create event" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.event_path(conn, :show, id)

      conn = get(conn, Routes.event_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Event"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "next event" do
    test "open next event page", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @next_attrs)
      conn = get(conn, Routes.event_path(conn, :next))

      response = html_response(conn, 200)

      assert response =~ "Next Event"
      assert response =~ "Left:"
    end

    test "open next event page without event", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)

      conn = get(conn, Routes.event_path(conn, :next))
      assert html_response(conn, 200) =~ "Not events"
    end
  end

  describe "edit event" do
    setup [:create_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get(conn, Routes.event_path(conn, :edit, event))
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "update event" do
    setup [:create_event]

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @update_attrs)
      assert redirected_to(conn) == Routes.event_path(conn, :show, event)

      conn = get(conn, Routes.event_path(conn, :show, event))
      assert html_response(conn, 200) =~ "Event updated successfully"
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, Routes.event_path(conn, :delete, event))
      assert redirected_to(conn) == Routes.event_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.event_path(conn, :show, event))
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
