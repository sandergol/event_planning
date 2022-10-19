defmodule EventPlanningWeb.SessionController do
  use EventPlanningWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, params) do
    token = "token_auth_ok"
    password = "123456"

    conn =
      cond do
        get_session(conn, :token_auth) == token ->
          conn
          |> put_session(:token_auth, token)
          |> render(EventPlanningWeb.WelcomeView, :index)

        Enum.empty?(to_charlist(params["password"])) ->
          conn
          |> put_flash(:error, "Введите пароль")
          |> render("index.html")

        Plug.Crypto.secure_compare(password, params["password"]) ->
          conn
          |> put_session(:token_auth, token)
          |> put_flash(:info, "Вы вошли")
          |> render("index.html")

        true ->
          conn
          |> put_flash(:error, "Неверный пароль")
          |> render("index.html")
      end

    halt(conn)
  end
end
