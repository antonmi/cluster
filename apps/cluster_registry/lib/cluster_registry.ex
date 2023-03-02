defmodule ClusterRegistry do
  use GenServer

  defstruct [:node, :name, :pid]
  @type name :: atom | String.t()
  @type t :: %__MODULE__{node: node, name: name, pid: pid}

  @spec start_link(name()) :: GenServer.on_start()
  def start_link(name) when is_binary(name) or is_atom(name) do
    GenServer.start_link(__MODULE__, name, name: __MODULE__)
  end

  @impl true
  def init(name) do
    case :global.register_name(name, self()) do
      :yes ->
        state = %__MODULE__{node: Node.self(), name: name, pid: self()}
        :global.sync()
        {:ok, state}

      :no ->
        {:stop, :cannot_register}
    end
  end

  @spec state() :: ClusterRegistry.t()
  def state, do: GenServer.call(__MODULE__, :state)

  @impl true
  def handle_call(:state, _from, state), do: {:reply, state, state}

  @spec all_names() :: list(name)
  def all_names do
    :global.registered_names()
  end

  @spec info(node) :: ClusterRegistry.t()
  def info(node) do
    :rpc.call(node, ClusterRegistry, :state, [])
  end

  @spec list() :: list(ClusterRegistry.t())
  def list do
    {replies, _bad} =
      :global.registered_names()
      |> Enum.map(&node_with_name/1)
      |> :rpc.multicall(ClusterRegistry, :state, [])

    replies
  end

  @spec node_with_name(name) :: node | nil
  def node_with_name(name) do
    case :global.whereis_name(name) do
      :undefined ->
        nil

      pid when is_pid(pid) ->
        :erlang.node(pid)
    end
  end

  @spec all_nodes_with_prefix(name) :: list(node)
  def all_nodes_with_prefix(prefix) do
    :global.registered_names()
    |> Enum.filter(fn name -> String.starts_with?("#{name}", "#{prefix}") end)
    |> Enum.map(&node_with_name/1)
  end

  @spec random_node_with_prefix(name) :: node
  def random_node_with_prefix(prefix) do
    prefix
    |> all_nodes_with_prefix()
    |> Enum.random()
  end
end
