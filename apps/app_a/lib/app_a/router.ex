defmodule AppA.Router do
  use Plug.Router

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  get "/" do
    list = Node.list()
    send_resp(conn, 200, "Hey from AppA #{inspect(Node.self())}! Node.list: #{inspect(list)}")
  end

  get "/favicon.ico" do
    send_resp(conn, 200, "sorry, no icon")
  end

  match _ do
    send_resp(conn, 404, "NOT FOUND")
  end
end
