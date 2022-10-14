defmodule EventPlanning.Schedules.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :date_start, :utc_datetime
    field :date_end, :utc_datetime
    field :iteration, :string
    field :active, :integer

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:date_start, :date_end, :iteration, :active])
    |> validate_required([:date_start, :date_end])
    |> validate_active()
    |> validate_iteration()
  end

  defp validate_active(changeset) do
    active = get_field(changeset, :active)

    cond do
      is_nil(active) ->
        put_change(changeset, :active, 1)

      active not in [0, 1] ->
        add_error(changeset, :active, "valid value 0 or 1")

      true ->
        changeset
    end
  end

  # `validate_iteration/1` checks that `:iteration` contains only valid values:
  # `d=all` – repeat every day
  # `d=3;5;` – repeat on selected days of the week
  # `m=31` – repeat monthly
  # `y=12.31` – repeat yearly

  defp validate_iteration(changeset) do
    iteration = get_field(changeset, :iteration)

    if is_nil(iteration) do
      changeset
    else
      case iteration_check_regex(iteration) do
        {:ok, _} ->
          changeset

        {:error, regex} ->
          add_error(
            changeset,
            :iteration,
            "value \"#{iteration}\" #{inspect(regex)}"
          )
      end
    end
  end

  defp iteration_check_regex(value, i \\ 0) do
    regex_list = [
      everyday: ~r/^d=all$/,
      days_week: ~r/^d=([1-7];)+$/,
      monthly: ~r/^m=(\d|1\d|2\d|3[0-1])$/,
      annually: ~r/^y=(\d|1[0-2])\.(\d|1\d|2\d|3[0-1])$/
    ]

    regex = Enum.at(regex_list, i)

    cond do
      is_nil(regex) ->
        {:error, "invalid format"}

      value =~ elem(regex, 1) ->
        {:ok, true}

      true ->
        iteration_check_regex(value, i + 1)
    end
  end
end
