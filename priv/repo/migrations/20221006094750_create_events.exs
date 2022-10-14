defmodule EventPlanning.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :date_start, :utc_datetime
      add :date_end, :utc_datetime
      add :iteration, :string
      add :active, :integer

      timestamps()
    end
  end
end
