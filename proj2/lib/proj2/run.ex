defmodule Proj2.Runner do
    def start(num_of_nodes, topology, algorithm) do
      children = [
        Supervisor.child_spec({Proj2.Driver, {num_of_nodes, topology, algorithm}},
          id: num_of_nodes,
          restart: :permanent
        )
      ]
  
      # See https://hexdocs.pm/elixir/Supervisor.html
      # for other strategies and supported options
      opts = [strategy: :one_for_one, name: Proj2.Supervisor]
      Supervisor.start_link(children, opts)
      start_time = System.monotonic_time(:millisecond)
      Proj2.NodeSupervisor.wait_till_stopping_condition_reached(start_time)
    end
  
    def main() do
      cli_args = System.argv()
      main(cli_args)
    end
  
    def main(cli_args) do
      num_of_nodes = String.to_integer(Enum.at(cli_args, 0))
      topology = Enum.at(cli_args, 1)
  
      num_of_nodes =
        if(topology == "honeycomb" || topology == "randhoneycomb") do
          root = :math.pow(num_of_nodes, 1 / 2)
          num_of_nodes = :math.pow(:math.ceil(root), 2)
          trunc(num_of_nodes)
        else
          trunc(num_of_nodes)
        end
  
      num_of_nodes =
        if(topology == "3DTorus") do
          root = root = :math.pow(num_of_nodes, 1 / 3)
          num_of_nodes = :math.pow(:math.ceil(root), 2)
          trunc(num_of_nodes)
        else
          trunc(num_of_nodes)
        end
  
      algorithm = Enum.at(cli_args, 2)
  
      Proj2.Runner.start(num_of_nodes, topology, algorithm)
    end
  end
  