defmodule EventPlanningWeb.EventView do
  use EventPlanningWeb, :view

  alias EventPlanning.Utils

  def how_wait(event) do
    wait = Utils.how_wait(event)

    "Days #{wait.days} Hours #{wait.hour} Minutes #{wait.minute}"
  end
end
