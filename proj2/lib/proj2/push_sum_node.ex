defmodule Proj2.PushSumNode do
  use GenServer

  def start_link(node) do
    {:ok, pid} = GenServer.start_link(__MODULE__, node)
    {:ok, pid}
  end

  def init(args) do
    {:ok, {0, 0, 0, 0, []}}
  end

  def handle_cast({:send, recv_s, recv_w}, {s, w, count, isConverged, neighbors}) do
    # IO.puts s/w

    # IO.puts "#{s},#{w}"
    old_ratio = s / w
    s = s + recv_s
    w = w + recv_w

    s_new = s / 2
    w_new = w / 2

    new_ratio = recv_s / recv_w
    # IO.puts abs(new_ratio- old_ratio)
    isConverged =
      if(abs(new_ratio - old_ratio) <= 1.0e-10 && count > 2) do
        1
      else
        0
      end

    next_node = Enum.random(neighbors)
    GenServer.cast(next_node, {:send, s_new, w_new})

    count =
      if(abs(new_ratio - old_ratio) <= 1.0e-10) do
        count + 1
      else
        count
      end

    {:noreply, {s_new, w_new, count, isConverged, neighbors}}
  end

  def handle_cast({:initialize, i, map}, {s, w, count, isConverged, neighbors}) do
    s = i + 1
    neighbors = Map.get(map, self())
    w = 1
    # IO.puts "#{s},#{w}"
    {:noreply, {s, w, count, isConverged, neighbors}}
  end

  def handle_call(:node_state, from, {s, w, count, isConverged, neighbors}) do
    if(isConverged == 1) do
      {:reply, true, {s, w, count, isConverged, neighbors}}
    else
      {:reply, false, {s, w, count, isConverged, neighbors}}
    end
  end
end
