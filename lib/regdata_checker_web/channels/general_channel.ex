defmodule RegdataCheckerWeb.GeneralChannel do
  use RegdataCheckerWeb, :channel

  def join("general:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (general:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload |> handle_data
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp handle_data(%{"data" => data, "type" => type}) do
    result = type
    |> case do
      "inn" -> data |> Validators.is_inn
      "kpp" -> data |> Validators.is_kpp
      "ogrn" -> data |> Validators.is_ogrn
      _ -> false
    end
    %{
      datetime: DateTime.utc_now,
      data: data,
      type: type,
      result: result
    }
  end
end
