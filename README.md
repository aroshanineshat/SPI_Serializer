# SPI Serializer

I'm using this module to serialize a register to program several HMC792ALP4E. 


# Simulation 


iverilog was used for simulation. It's definitely faster than Vivado. The IP then is moved to Vivado to be appended to a bigger design. 

Make sure iverilog is installed. If you are using Ubuntu, it's there in the repository. To start the simulation, run the following:

```shell
~$ iverilog -Wall -o output module_tb.v SPI_Serializer.v
~$ vvp -lxt2 output
```

It will create a test.vcd with all the traces. 

# Plotting the digital waves 

Install GTKwave (It's in your repo if you are using Ubuntu) and then simply do:

```shell
~$ gtkwave test.vcd
```

# Diagrams

Here is the simulation output:

![Simulation Output] (img/SimulationOutput.png)

and this is a timing diagram from the datasheet:

![Datasheet Diagram] (img/DatasheetDiagram.png)

