clear,clc;
master = Experiment("Bcalib");

%%
temp = 100;
Freq = 2850:2:2910;
current_list = 0:0.010:0.100;

master.MW.off();
master.coil.off();

%%
master.coil.on();



master.cryo.temperature_K(temp);

for i = 1:size(current_list,2)
master.coil.current_A(current_list(i));
master.odmr(Freq, sprintf("ID0%02d__I%.4fA_T%.2fK", i, current_list(i), temp));
end

master.coil.off();