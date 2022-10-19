defmodule EventPlanningWeb.EventController do
  use EventPlanningWeb, :controller
  # import Phoenix.Component

  alias EventPlanning.Schedules
  alias EventPlanning.Schedules.Event

  def index(conn, params) do
    events =
      cond do
        params["view"] == "all" ->
          Schedules.list_events()

        params["view"] == "year" ->
          Schedules.list_current_year_events()

        params["view"] == "month" ->
          Schedules.list_current_month_events()

        true ->
          Schedules.list_current_week_events()
      end

    render(conn, "index.html", events: events, view: params["view"])
  end

  def new(conn, _params) do
    changeset = Schedules.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Schedules.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Schedules.get_event!(id)
    render(conn, "show.html", event: event)
  end

  def next(conn, _params) do
    event = Schedules.next_event()
    render(conn, "show.html", event: event, next: true)
  end

  def edit(conn, %{"id" => id}) do
    event = Schedules.get_event!(id)
    changeset = Schedules.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Schedules.get_event!(id)

    case Schedules.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Schedules.get_event!(id)
    {:ok, _event} = Schedules.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
