defmodule LiveElement.Socket do
  @moduledoc """
  The LiveView socket for Phoenix Endpoints.

  This is typically mounted directly in your endpoint.

      socket "/live", Phoenix.LiveView.Socket

  """
  use Phoenix.Socket

  require Logger

  defstruct id: nil,
            endpoint: nil,
            view: nil,
            parent_pid: nil,
            root_pid: nil,
            router: nil,
            assigns: %{__changed__: %{}},
            private: %{__changed__: %{}},
            fingerprints: Phoenix.LiveView.Diff.new_fingerprints(),
            redirected: nil,
            host_uri: nil,
            transport_pid: nil

  @typedoc "The data in a LiveView as stored in the socket."
  @type assigns :: map

  @type fingerprints :: {nil, map} | {binary, map}

  @type t :: %__MODULE__{
          id: binary(),
          endpoint: module(),
          view: module(),
          parent_pid: nil | pid(),
          root_pid: pid(),
          router: module(),
          assigns: assigns,
          private: map(),
          fingerprints: fingerprints,
          redirected: nil | tuple(),
          host_uri: URI.t() | :not_mounted_at_router,
          transport_pid: pid() | nil
        }

  channel "lve:*", LiveElement.Channel

  @impl Phoenix.Socket
  def connect(_params, %Phoenix.Socket{} = socket, connect_info) do
    {:ok, put_in(socket.private[:connect_info], connect_info)}
  end

  @impl Phoenix.Socket
  def id(socket), do: socket.private.connect_info[:session]["live_socket_id"]
end
