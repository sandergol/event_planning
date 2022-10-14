defmodule EventPlanning.SchedulesTest do
  use EventPlanning.DataCase

  alias EventPlanning.Schedules

  describe "events" do
    alias EventPlanning.Schedules.Event

    import EventPlanning.SchedulesFixtures

    @invalid_attrs %{active: nil, date_end: nil, date_start: nil, iteration: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Schedules.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Schedules.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        active: 1,
        date_end: ~U[2022-10-05 09:47:00Z],
        date_start: ~U[2022-10-05 09:47:00Z],
        iteration: nil
      }

      assert {:ok, %Event{} = event} = Schedules.create_event(valid_attrs)
      assert event.active == 1
      assert event.date_end == ~U[2022-10-05 09:47:00Z]
      assert event.date_start == ~U[2022-10-05 09:47:00Z]
      assert event.iteration == nil
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedules.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        active: 1,
        date_end: ~U[2022-10-06 09:47:00Z],
        date_start: ~U[2022-10-06 09:47:00Z],
        iteration: nil
      }

      assert {:ok, %Event{} = event} = Schedules.update_event(event, update_attrs)
      assert event.active == 1
      assert event.date_end == ~U[2022-10-06 09:47:00Z]
      assert event.date_start == ~U[2022-10-06 09:47:00Z]
      assert event.iteration == nil
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedules.update_event(event, @invalid_attrs)
      assert event == Schedules.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Schedules.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Schedules.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Schedules.change_event(event)
    end
  end
end
