defmodule EventPlanningWeb.RoomChannel do
  use EventPlanningWeb, :channel

  @impl true
  def join("room:lobby", _payload, socket) do
    # if authorized?(payload) do
      {:ok, socket}
    # else
      # {:error, %{reason: "unauthorized"}}
    # end
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  # @impl true
  # def handle_in("shout", payload, socket) do
  #   IO.puts "shout!!!!!!!!!!!!!!!!!!!!"
  #   IO.puts "payload: " <> inspect(payload)
  #   broadcast(socket, "shout", payload)
  #   {:noreply, socket}
  # end

  def handle_in("change_schedule", %{"id" => id}, socket) do
    IO.puts "change_schedule: " <> inspect(id)
    broadcast!(socket, "change_schedule", %{id: true})
    {:noreply, socket}
  end

  # Рассылает принятое сообщение на остальных клиентов:
  # intercept ["user_joined"]

  # def handle_out("user_joined", msg, socket) do
  #   IO.puts "user_joined!!!!!!!!!!!!!!!!!"
  #   IO.puts "msg: " <> inspect(msg)
  #   # if Accounts.ignoring_user?(socket.assigns[:user], msg.user_id) do
  #     # {:noreply, socket}
  #   # else
  #     push(socket, "user_joined", msg)
  #     {:noreply, socket}
  #   # end
  # end

  # Add authorization logic here as required.
  # defp authorized?(_payload) do
  #   true
  # end
end
