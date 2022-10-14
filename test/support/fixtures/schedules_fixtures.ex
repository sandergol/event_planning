defmodule EventPlanning.SchedulesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EventPlanning.Schedules` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        active: 1,
        date_end: ~U[2022-10-05 09:47:00Z],
        date_start: ~U[2022-10-05 09:47:00Z],
        iteration: nil
      })
      |> EventPlanning.Schedules.create_event()

    event
  end
end
