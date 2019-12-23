defmodule Proj2.Driver do
  use GenServer

  # Client Side

  def start_link({num_of_nodes, topology, algorithm}) do
    {:ok, pid} =
      GenServer.start_link(__MODULE__, {num_of_nodes, topology, algorithm}, name: __MODULE__)

    if(algorithm == "push-sum") do
      GenServer.cast(pid, {:start_push, {num_of_nodes, topology, algorithm}})
    else
      GenServer.cast(pid, {:start_gossip, {num_of_nodes, topology, algorithm}})
    end

    {:ok, pid}
  end

  # Server Side

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:start_push, {num_of_nodes, topology, algorithm}}, _state) do
    nodes = Proj2.NodeSupervisor.create_workers(num_of_nodes, algorithm)
    map = Proj2.Topology.get_topology(nodes, topology)

    Enum.each(0..(num_of_nodes - 1), fn x ->
      GenServer.cast(Enum.at(nodes, x), {:initialize, x, map})
    end)

    start_node = Enum.at(nodes, length(nodes) - 1)
    GenServer.cast(start_node, {:send, 1, 1})
    {:noreply, {nodes}}
  end

  def handle_cast({:start_gossip, {num_of_nodes, topology, algorithm}}, _state) do
    nodes = Proj2.NodeSupervisor.create_workers(num_of_nodes, algorithm)
    # IO.puts length(nodes)
    map = Proj2.Topology.get_topology(nodes, topology)
    # IO.inspect map
    Enum.each(nodes, fn x ->
      GenServer.cast(x, {:initialize, map})
    end)

    start_node = Enum.random(nodes)

    # IO.inspect start_node
    GenServer.cast(start_node, {:send})
    {:noreply, {nodes}}
  end

  def handle_call(:check_state, _from, {nodes}) do
    result =
      Enum.map(nodes, fn x ->
        GenServer.call(x, :node_state)
      end)

    # IO.inspect result

    result = Enum.filter(result, fn x -> x != false end)
    # IO.inspect length(result)
    if(length(result) / length(nodes) > 0.9) do
      {:reply, true, {nodes}}
    else
      {:reply, false, {nodes}}
    end
  end
end
