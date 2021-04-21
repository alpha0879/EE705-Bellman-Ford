 # EE705-Bellman-Ford

# the images are not final, just using the images for documentation purpose - we can change it later

The project implements Bellman Ford Algorithm using a 5 stage pipeline with data parallelism to process multiple edges in each clock cycle.
The implementation is based on the paper cited in [1]. 

### The graph is displayed on a VGA Monitor as shown in Figure below, The user can enter the source and destination using switches connected to the FPGA Board.

![Alt text](https://github.com/nikhil879/EE705-Bellman-Ford/blob/master/Graphs/graph_vga.jpeg?raw=true "Dataflow of FSM")

### The flow of execution is shown in the FSM below. 

![Alt text](https://github.com/nikhil879/EE705-Bellman-Ford/blob/master/FSM/FSM.jpeg?raw=true "Dataflow of FSM")

### Once the source and destination are entered, the shortest path will be displayed on the VGA

## References
<a id="1">[1]</a> 
S. Zhou, et al., "Accelerating Large-Scale Single-Source Shortest Path on FPGA," IEEE International Parallel and Distributed Processing Symposium Workshop, 2015, pp. 129-136, 2015.
