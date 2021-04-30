 # EE705-Bellman-Ford

The project implements Bellman Ford Algorithm using a 5 stage pipeline with data parallelism to process multiple edges in each clock cycle.
The implementation is based on the paper cited in [1]. 

The graph is displayed on a VGA Monitor as shown in Figure below, The user can enter the source and destination using switches connected to the FPGA Board. The shortest path is displayed using "white dots" on top of nodes. For instance in the below figure, the graph displays the shortest distance between nodes 1 and 14 .

![Alt text](https://github.com/nikhil879/EE705-Bellman-Ford/blob/master/Graphs/graph_vga.jpeg?raw=true "Dataflow of FSM")

### The flow of execution of the FSM is shown below. 

![Alt text](https://github.com/nikhil879/EE705-Bellman-Ford/blob/master/FSM/FSM_Optimised_Quartus_folder/FSM_State_diagram.jpeg?raw=true "Dataflow of FSM")


## References
<a id="1">[1]</a> 
S. Zhou, et al., "Accelerating Large-Scale Single-Source Shortest Path on FPGA," IEEE International Parallel and Distributed Processing Symposium Workshop, 2015, pp. 129-136, 2015.
