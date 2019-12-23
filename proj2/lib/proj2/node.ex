defmodule Proj2.Node do
  use GenServer

  # Client Side

  def start_link(node) do
    {:ok, pid} = GenServer.start_link(__MODULE__, node)
    {:ok, pid}
  end

  def handle_cast({:send}, {counter, state_map}) do
    neighbors = state_map
    state_counter = counter

    if(state_counter < 10) do
      next_node = Enum.random(neighbors)
      GenServer.cast(next_node, {:send})

      Process.sleep(1)

      GenServer.cast(self(), {:send})
    end

    {:noreply, {state_counter + 1, neighbors}}
  end

  def handle_cast({:initialize, map}, {counter, neighbors}) do
    neighbors = Map.get(map, self())
    {:noreply, {counter, neighbors}}
  end

  def handle_call(:node_state, from, {counter, neighbors}) do
    if(counter >= 1) do
      {:reply, true, {counter, neighbors}}
    else
      {:reply, false, {counter, neighbors}}
    end
  end

  # Server Side

  def init(args) do
    {:ok, {0, []}}
  end
end
