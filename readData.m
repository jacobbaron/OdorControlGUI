T=timer;  
set(T,'BusyMode','queue');
set(T,'ExecutionMode','fixedRate');
set(T,'Period',0.1);
set(T,'TasksToExecute',100);
set(T,'timerfcn',{@Task});
start(T);