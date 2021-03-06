/*********************************************
 * OPL 12.10.0.0 Model
 * Author: marcel.cases
 * Creation Date: 19 Mar 2021 at 10:29:24
 *********************************************/

int nTasks = ...;
int nCPUs = ...;

range T = 1..nTasks;
range C = 1..nCPUs;

float rt[t in T]=...;
float rc[c in C]=...;

dvar boolean x_tc [t in T, c in C];
dvar float+ z;

// Pre-processing
execute {
	var totalLoad = 0;
	for (var t = 1; t <= nTasks; t++)
		totalLoad += rt[t];
	writeln("Total load " + totalLoad);
	
	var totalCap = 0;
	for (var c = 1; c <= nCPUs; c++)
		totalCap += rc[c];
	writeln("Total capacity " + totalCap);
	
	if (totalLoad <= totalCap) {
		writeln("Computers have capacity enough to handle all the tasks");
	} else {
		writeln("Computers DO NOT HAVE capacity enough to handle all the tasks");
		stop();
	}
};

// Objective
minimize z;

subject to {
	
	// Constraint 1
	forall(t in T)
		sum(c in C) x_tc [t , c] == 1;
	
	// Constraint 2
	forall(c in C)
		sum(t in T) rt [t] * x_tc[t , c] <= rc[c];
	
	// Constraint 3
	forall(c in C)
		z >= (1 / rc[c]) * sum(t in T) rt[t] * x_tc[t , c];
}

// Post-processing (moved to main.mod)
/*execute {
	for (var c = 1; c <= nCPUs; c++) {
		var load = 0;
		for(var t = 1; t <= nTasks; t++)
			load += (rt[t] * x_tc[t][c]);
		load = (1 / rc[c]) * load ;
		writeln("CPU " + c + " loaded at " + 100 * load + "%");
	}
};*/

 