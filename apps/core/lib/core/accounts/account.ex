defmodule Core.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :phone, :string
    field :state, :string, default: ""
    field :username, :string, default: ""
    field :error, :string, default: ""
    field :api_id, :integer
    field :api_hash, :string
    field :is_enable, :boolean, default: false
    field :is_working, :boolean, default: false
    field :pid, :integer, default: 0
    field :verify_at, :utc_datetime
    field :active_at, :utc_datetime

    belongs_to :user, Core.Users.User

    timestamps()
  end

  @doc false
  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:phone, :api_id, :api_hash])
    |> validate_required([:phone, :api_id, :api_hash, :user_id])
  end
end
