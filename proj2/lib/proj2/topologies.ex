defmodule Proj2.Topology do
  def get_topology(nodes, topology) do
    neighbors = get_neighbors(nodes, topology)
    map = Map.new()
    map = Enum.zip(nodes, neighbors) |> Enum.into(%{})
    map
  end

  def get_neighbors(nodes, topology) do
    totalNodes = length(nodes)

    cond do
      topology == "full" ->
        Enum.map(nodes, fn x -> nodes -- [x] end)

      topology == "line" ->
        for i <- 0..(totalNodes - 1) do
          neighborsList =
            cond do
              i == 0 -> [i + 1]
              i == totalNodes - 1 -> [i - 1]
              i > 0 && i < totalNodes -> [i - 1, i + 1]
            end

          [] ++ Enum.map(neighborsList, fn x -> Enum.at(nodes, x) end)
        end

      topology == "rand2D" ->
        first_map = %{}

        second_map =
          Enum.map(nodes, fn x -> Map.put(first_map, x, [:rand.uniform()] ++ [:rand.uniform()]) end)

        # IO.inspect map2

        Enum.reduce(second_map, [], fn key, value_list ->
          [key_list] = Map.keys(key)
          coord_list = Map.values(key)

          mapped_list =
            [] ++
              Enum.map(second_map, fn x ->
                if distance(coord_list, Map.values(x)) do
                  Enum.at(Map.keys(x), 0)
                end
              end)

          filtered_mapped_list = Enum.filter(mapped_list, &(!is_nil(&1)))
          new_coord_list = filtered_mapped_list -- [key_list]

          value_list ++ [new_coord_list]
        end)

      topology = "3Dtorus" ->
        row_count = round(:math.pow(totalNodes, 1 / 3))
        column_count = row_count * row_count

        for i <- 1..totalNodes do
          neighborsList =
            cond do
              i == 1 ->
                [
                  i + 1,
                  i + row_count,
                  i + column_count,
                  totalNodes - column_count + 1,
                  i + row_count - 1,
                  i + column_count - row_count
                ]

              i == row_count ->
                [
                  i - 1,
                  i + row_count,
                  i + column_count,
                  i + column_count - row_count,
                  i - row_count + 1,
                  totalNodes - column_count + row_count
                ]

              i == column_count - row_count + 1 ->
                [
                  i + 1,
                  i - row_count,
                  i + column_count,
                  totalNodes - row_count + 1,
                  i + row_count - 1,
                  1
                ]

              i == column_count ->
                [
                  i - 1,
                  i - row_count,
                  i + column_count,
                  i - column_count + row_count,
                  totalNodes,
                  i - row_count + 1
                ]

              i == 1 + column_count ->
                [
                  i + 1,
                  i - column_count,
                  i + row_count,
                  i + column_count,
                  i + column_count - row_count,
                  i + row_count - 1
                ]

              i == row_count + column_count ->
                [
                  i - 1,
                  i - column_count,
                  i + row_count,
                  i + column_count,
                  i - row_count + 1,
                  i + column_count - row_count
                ]

              i == 2 * column_count - row_count + 1 ->
                [
                  i + 1,
                  i - column_count,
                  i - row_count,
                  i + column_count,
                  i - column_count + row_count,
                  i + row_count - 1
                ]

              i == 2 * column_count ->
                [
                  i - 1,
                  i - column_count,
                  i - row_count,
                  i + column_count,
                  i - column_count + row_count,
                  i - row_count + 1
                ]

              i == 1 + 2 * column_count ->
                [
                  i + 1,
                  i + row_count,
                  i - column_count,
                  i + row_count - 1,
                  i + column_count - row_count,
                  1
                ]

              i == row_count + 2 * column_count ->
                [
                  i - 1,
                  i + row_count,
                  i - column_count,
                  i - row_count + 1,
                  i + column_count - totalNodes,
                  i + column_count - row_count
                ]

              i == column_count + 2 * column_count - row_count + 1 ->
                [
                  i + 1,
                  i - row_count,
                  i - column_count,
                  i - column_count + row_count,
                  i + column_count - totalNodes,
                  i + row_count - 1
                ]

              i == totalNodes ->
                [
                  i - 1,
                  i - row_count,
                  i - column_count,
                  i - row_count + 1,
                  i - column_count + row_count,
                  column_count
                ]

              i < row_count ->
                [
                  i - 1,
                  i + 1,
                  i + row_count,
                  i + column_count,
                  i + column_count - row_count,
                  totalNodes - column_count + row_count - 1
                ]

              i > column_count - row_count + 1 and i < column_count ->
                [
                  i - 1,
                  i + 1,
                  i - row_count,
                  i + column_count,
                  totalNodes - 1,
                  i - column_count + row_count
                ]

              rem(i - 1, row_count) == 0 and i < column_count ->
                [
                  i + 1,
                  i - row_count,
                  i + row_count,
                  i + column_count,
                  totalNodes - column_count + row_count + 1,
                  i + row_count - 1
                ]

              rem(i, row_count) == 0 and i < column_count ->
                [
                  i - 1,
                  i - row_count,
                  i + row_count,
                  i + column_count,
                  totalNodes - row_count,
                  i - row_count + 1
                ]

              i < column_count ->
                [
                  i - 1,
                  i + 1,
                  i - row_count,
                  i + row_count,
                  i + column_count,
                  totalNodes - column_count + i
                ]

              i < column_count + row_count and i > 2 * row_count ->
                [
                  i - 1,
                  i + 1,
                  i + column_count,
                  i - column_count,
                  i + row_count,
                  i + column_count - row_count
                ]

              i > 2 * column_count - row_count + 1 and i < 2 * column_count ->
                [
                  i - 1,
                  i + 1,
                  i - row_count,
                  i + column_count,
                  i - column_count,
                  i - column_count + row_count
                ]

              rem(i - 1, row_count) == 0 and i < 2 * column_count ->
                [
                  i + 1,
                  i - row_count,
                  i + row_count,
                  i + column_count,
                  i - column_count,
                  i + row_count - 1
                ]

              rem(i, row_count) == 0 and i < 2 * column_count ->
                [
                  i - 1,
                  i - row_count,
                  i + row_count,
                  i + column_count,
                  i - column_count,
                  i - row_count + 1
                ]

              i < 2 * column_count + row_count and i > 2 * column_count ->
                [
                  i - 1,
                  i + 1,
                  i + row_count,
                  i - column_count,
                  i + column_count - row_count,
                  i + column_count - totalNodes
                ]

              i > 3 * column_count - row_count + 1 and i < 3 * column_count ->
                [
                  i - 1,
                  i + 1,
                  i - row_count,
                  i - column_count,
                  i - column_count + row_count,
                  column_count - (totalNodes - i)
                ]

              rem(i - 1, row_count) == 0 and i < 3 * column_count ->
                [
                  i + 1,
                  i - row_count,
                  i + row_count,
                  i - column_count,
                  totalNodes - i - 1,
                  i + row_count - 1
                ]

              rem(i, row_count) == 0 and i < 3 * column_count ->
                [
                  i - 1,
                  i - row_count,
                  i + row_count,
                  i - column_count,
                  totalNodes - i + row_count,
                  i - row_count + 1
                ]

              i < 3 * column_count and i > 2 * column_count ->
                [i - 1, i + 1, i - row_count, i + row_count, i - column_count, totalNodes - i + 1]

              true ->
                [i - 1, i + 1, i - row_count, i + row_count, i + column_count, i - column_count]
            end

          [] ++ Enum.map(neighborsList, fn x -> Enum.at(nodes, x - 1) end)
        end

      topology = "honeycomb" ->
        node_count = Enum.count(nodes)
        row_count = round(:math.sqrt(node_count))

        nodes
        |> Enum.with_index()
        |> Enum.map(fn {node_id, i} ->
          neighbors =
            cond do
              # first row, odd i
              i <= row_count - 1 and rem(rem(i, row_count), 2) != 0 ->
                [Enum.at(nodes, i - 1), Enum.at(nodes, i + row_count)]

              # first row, even i, not last element
              i <= row_count - 1 and rem(rem(i, row_count), 2) == 0 and
                  row_count - rem(i, row_count) != 1 ->
                [Enum.at(nodes, i + 1), Enum.at(nodes, i + row_count)]

              # first row, even i, last element
              i <= row_count - 1 and rem(rem(i, row_count), 2) == 0 and
                  row_count - rem(i, row_count) == 1 ->
                [Enum.at(nodes, i + row_count)]

              # odd row, odd i
              rem(div(i, row_count) + 1, 2) != 0 and rem(rem(i, row_count), 2) != 0 ->
                [
                  Enum.at(nodes, i - 1),
                  Enum.at(nodes, i + row_count),
                  Enum.at(nodes, i - row_count)
                ]

              # odd row, even i, not last i
              rem(div(i, row_count) + 1, 2) != 0 and rem(rem(i, row_count), 2) == 0 and
                  row_count - rem(i, row_count) != 1 ->
                [
                  Enum.at(nodes, i + 1),
                  Enum.at(nodes, i + row_count),
                  Enum.at(nodes, i - row_count)
                ]

              # even row , odd i, not first i, not last member
              rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i, row_count), 2) != 0 and
                rem(i, row_count) != 0 and row_count - rem(i, row_count) != 1 ->
                [
                  Enum.at(nodes, i + 1),
                  Enum.at(nodes, i + row_count),
                  Enum.at(nodes, i - row_count)
                ]

              rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i + 1, row_count), 2) == 0 and
                  rem(i, row_count) == 0 ->
                [Enum.at(nodes, i - row_count), Enum.at(nodes, i + row_count)]

              # even row, even i, not first i
              rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i, row_count), 2) == 0 and
                  rem(i, row_count) != 0 ->
                [
                  Enum.at(nodes, i - 1),
                  Enum.at(nodes, i + row_count),
                  Enum.at(nodes, i - row_count)
                ]

              # even row, even i, first i
              rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i, row_count), 2) == 0 and
                  rem(i, row_count) == 0 ->
                [Enum.at(nodes, i + row_count), Enum.at(nodes, i - row_count)]

              # even row, odd i, first i
              (rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i, row_count), 2) != 0 and
                 rem(i, row_count) == 0) or row_count - rem(i, row_count) == 1 ->
                [Enum.at(nodes, i + row_count), Enum.at(nodes, i - row_count)]

              # odd row, odd i, last member
              rem(div(i, row_count) + 1, 2) != 0 and rem(rem(i, row_count), 2) != 0 and
                  row_count - rem(i, row_count) == 1 ->
                [Enum.at(nodes, i + row_count), Enum.at(nodes, i - row_count)]

              # odd row, even i, last member
              rem(div(i, row_count) + 1, 2) != 0 and rem(rem(i, row_count), 2) == 0 and
                  row_count - rem(i, row_count) == 1 ->
                [Enum.at(nodes, i + row_count), Enum.at(nodes, i - row_count)]
            end

          Enum.filter(neighbors, & &1)
        end)

      case = "randhoneycomb" ->
        node_count = Enum.count(nodes)
        row_count = round(:math.sqrt(node_count))

        nodes
        |> Enum.with_index()
        |> Enum.map(fn {node_id, i} ->
          neighborsList =
            cond do
              
              i <= row_count - 1 and rem(rem(i, row_count), 2) != 0 ->
                [Enum.at(nodes, i - 1), Enum.at(nodes, i + row_count)]

              
              i <= row_count - 1 and rem(rem(i, row_count), 2) == 0 and
                  row_count - rem(i, row_count) != 1 ->
                [Enum.at(nodes, i + 1), Enum.at(nodes, i + row_count)]

              
              i <= row_count - 1 and rem(rem(i, row_count), 2) == 0 and
                  row_count - rem(i, row_count) == 1 ->
                [Enum.at(nodes, i + row_count)]

              
              rem(div(i, row_count) + 1, 2) != 0 and rem(rem(i, row_count), 2) != 0 ->
                [
                  Enum.at(nodes, i - 1),
                  Enum.at(nodes, i + row_count),
                  Enum.at(nodes, i - row_count)
                ]

              
              rem(div(i, row_count) + 1, 2) != 0 and rem(rem(i, row_count), 2) == 0 and
                  row_count - rem(i, row_count) != 1 ->
                [
                  Enum.at(nodes, i + 1),
                  Enum.at(nodes, i + row_count),
                  Enum.at(nodes, i - row_count)
                ]

              
              rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i, row_count), 2) != 0 and
                rem(i, row_count) != 0 and row_count - rem(i, row_count) != 1 ->
                [
                  Enum.at(nodes, i + 1),
                  Enum.at(nodes, i + row_count),
                  Enum.at(nodes, i - row_count)
                ]

              rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i + 1, row_count), 2) == 0 and
                  rem(i, row_count) == 0 ->
                [Enum.at(nodes, i - row_count), Enum.at(nodes, i + row_count)]

              
              rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i, row_count), 2) == 0 and
                  rem(i, row_count) != 0 ->
                [
                  Enum.at(nodes, i - 1),
                  Enum.at(nodes, i + row_count),
                  Enum.at(nodes, i - row_count)
                ]

              
              rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i, row_count), 2) == 0 and
                  rem(i, row_count) == 0 ->
                [Enum.at(nodes, i + row_count), Enum.at(nodes, i - row_count)]

              
              (rem(div(i, row_count) + 1, 2) == 0 and rem(rem(i, row_count), 2) != 0 and
                 rem(i, row_count) == 0) or row_count - rem(i, row_count) == 1 ->
                [Enum.at(nodes, i + row_count), Enum.at(nodes, i - row_count)]

              
              rem(div(i, row_count) + 1, 2) != 0 and rem(rem(i, row_count), 2) != 0 and
                  row_count - rem(i, row_count) == 1 ->
                [Enum.at(nodes, i + row_count), Enum.at(nodes, i - row_count)]

              rem(div(i, row_count) + 1, 2) != 0 and rem(rem(i, row_count), 2) == 0 and
                  row_count - rem(i, row_count) == 1 ->
                [Enum.at(nodes, i + row_count), Enum.at(nodes, i - row_count)]
            end

          l = [] ++ Enum.filter(neighborsList, & &1)
          l1 = nodes -- [Enum.at(nodes, i - 1)]
          l1 = l1 -- l
          l ++ [Enum.random(l1)]
        end)
    end
  end

  def distance(c1, c2) do
    c1 = Enum.at(c1, 0)
    c2 = Enum.at(c2, 0)

    x_dist = :math.pow(Enum.at(c2, 0) - Enum.at(c1, 0), 2)
    y_dist = :math.pow(Enum.at(c2, 1) - Enum.at(c1, 1), 2)
    dist = round(:math.sqrt(x_dist + y_dist))

    cond do
      dist > 0.1 -> false
      dist <= 0.1 -> true
    end
  end
end
