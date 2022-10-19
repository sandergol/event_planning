defmodule EventPlanning.Utils do
  def next_event?(assigns) do
    Map.get(assigns, :next) == true
  end

  def how_wait(event) do
    current_time = DateTime.utc_now()

    days = (DateTime.diff(event.date_start, current_time) / 60 / 60 / 24) |> trunc()

    hour =
      (DateTime.diff(event.date_start, DateTime.add(current_time, days, :day)) / 60 / 60)
      |> trunc()

    minute =
      (DateTime.diff(event.date_start, DateTime.add(current_time, hour, :hour)) / 60) |> trunc()

    %{
      days: days,
      hour: hour,
      minute: minute
    }
  end
end
