defmodule Proj2.NodeSupervisor do
  use Application

  def create_workers(num_of_nodes, algorithm) do
    list = Enum.to_list(1..num_of_nodes)

    children =
      if(algorithm == "push-sum") do
        Enum.map(list, fn x ->
          Supervisor.child_spec({Proj2.PushSumNode, []}, id: x, restart: :permanent)
        end)
      else
        Enum.map(list, fn x ->
          Supervisor.child_spec({Proj2.Node, []}, id: x, restart: :permanent)
        end)
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Proj2.NodeSupervisor]
    Supervisor.start_link(children, opts)

    # returns a list of PID's of the children    
    result = Supervisor.which_children(Proj2.NodeSupervisor)
    Enum.map(result, fn {_, child, _, _} -> child end)
  end

  def wait_till_stopping_condition_reached(start_time) do
    is_stopping_condition_reached? = GenServer.call(Proj2.Driver, :check_state, 50000)

    if(is_stopping_condition_reached?) do
      IO.puts("Time taken:")
      end_time = System.monotonic_time(:millisecond)
      time_taken = end_time - start_time
      IO.inspect(time_taken)
      IO.puts("Converged")
    end

    unless is_stopping_condition_reached? do
      wait_till_stopping_condition_reached(start_time)
    end
  end
end
