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

  # def will_happen(event) do
  # {
  #   id: 25,
  #   date_start: ~U[2022-10-01 08:00:00Z],
  #   date_end: ~U[2022-10-01 10:00:00Z],
  #   iteration: "d=1;",
  #   active: 1,
  #   inserted_at: ~N[2022-10-12 18:41:10],
  #   updated_at: ~N[2022-10-12 18:41:10]
  # }

  # start_day_week = Date.day_of_week(event.date_start) #=> 6
  # current_day_week = Date.day_of_week(Date.utc_today()) #=> 4
  # compare_date = DateTime.diff(event.date_start, DateTime.utc_now)

  # date_start_match_day_week =
  #   event.iteration == "d=all" or
  #     event.iteration =~ to_string(start_day_week)

  # if date_start_match_day_week do
  #   event.date_start
  # else
  #   cond do
  #     compare_date >= 0 ->
  #       # trunc(compare_date / 60 / 60 / 24)
  #       DateTime.utc_now |> DateTime.add(compare_date)

  #     true ->
  #       "No calculation for this repeat format"
  #   end
  # end
  # end
end
