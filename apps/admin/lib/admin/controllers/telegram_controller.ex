defmodule Admin.TelegramController do
  use Admin, :controller

  plug :authorize_user
  plug :set_authorization_flag

  alias Core.Accounts

  def accounts(conn, _params) do
    accounts = Accounts.list_accounts()
    changeset = Accounts.Account.changeset(%Accounts.Account{})
    render(conn, "accounts.html", accounts: accounts, changeset: changeset)
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    (user && (Integer.to_string(user.id) == conn.params["user_id"] || Core.RoleChecker.is_admin?(user)))
  end

  defp authorize_user(conn, _opts) do
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that post!")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt
    end
  end

  defp set_authorization_flag(conn, _opts) do
    assign(conn, :author_or_admin, is_authorized_user?(conn))
  end

end
