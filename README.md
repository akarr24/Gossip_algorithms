# Gossip_algorithms
##Instructions to run the program
Run the command- mix escript.build
After building, run the program by executing escript my_program numNodes topology algorithm.
5. For example – escript my_program 100 full gossip
6. The program will execute.
Note: If the topologies don’t converge, terminate the program by pressing ctrl + c, and re-execute the program.

##What is working:
Topologies:
1. Full: Every node is neighbor to every other node.
2. Line: Nodes form a queue. Each node has two neighbors except for the first and the last node.
3. Random 2D: Nodes are randomly placed at x, y co-ordinates on a 1x1 grid. Two nodes are connected if the distance between them is less than or equal to 0.1 units.
4. 3D Torus: Nodes are arranged in a three-dimensional grid with each node having six neighbors.
5. HoneyComb: Nodes are arranged in a hexagonal pattern resembling that of a honeycomb. Each node can have maximum of three neighbors.
6. Random HoneyComb: Same as HoneyComb but one other random neighbor is selected from the list of all nodes.
Convergence is achieved for all topologies for both algorithms.
