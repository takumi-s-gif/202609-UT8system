clear,clc;
master = Experiment("diamag9");

%%
temp_list = [90 71:1:75];
Freq = 2850:2:2910;

master.MW.off();
master.coil.off();

%%
master.coil.on();
for i = 1:size(temp_list,2)
master.cryo.temperature_K(temp_list(i));

current = 0;
master.coil.current_A(current);
master.odmr(Freq, sprintf("ID0%02d__I%.4fA_T%.2fK", 2*i-1, current, temp_list(i)));

current = 0.075;
master.coil.current_A(current);
master.odmr(Freq, sprintf("ID0%02d__I%.4fA_T%.2fK", 2*i, current, temp_list(i)));

master.coil.current_A(0);
end
master.coil.off();