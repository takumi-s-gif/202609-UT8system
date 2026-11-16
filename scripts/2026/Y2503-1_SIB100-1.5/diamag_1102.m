clear,clc;
master = Experiment("diamag");

%%
temp_list = 80:1:90;
Freq = 2850:2:2910;

master.MW.off();
master.coil.off();

%%
master.coil.on();

master.cryo.temperature_K(100);
master.coil.current_A(0);
master.odmr(Freq, sprintf("ID0%02d__I0A_T%.2fK", 1, temp_list(i)));

master.cryo.temperature_K(80);
master.coil.current_A(0);
master.odmr(Freq, sprintf("ID0%02d__I0A_T%.2fK", 2, temp_list(i)));

for i = 1:size(temp_list,2)
master.cryo.temperature_K(temp_list(i));

current = 0.100;
master.coil.current_A(current);
master.odmr(Freq, sprintf("ID0%02d__I%.4fA_T%.2fK", 2*i+1, current, temp_list(i)));
end

master.coil.off();

%%
clear,clc;
master = Experiment("diamag2");

%%
temp_list = 70:1:80;
Freq = 2850:2:2910;

master.MW.off();
master.coil.off();

%%
master.coil.on();

master.cryo.temperature_K(100);
master.coil.current_A(0);
master.odmr(Freq, sprintf("ID0%02d__I0A_T%.2fK", 1, 100));

master.cryo.temperature_K(70);
master.coil.current_A(0);
master.odmr(Freq, sprintf("ID0%02d__I0A_T%.2fK", 2, 70));

for i = 1:size(temp_list,2)
master.cryo.temperature_K(temp_list(i));

current = 0.100;
master.coil.current_A(current);
master.odmr(Freq, sprintf("ID0%02d__I%.4fA_T%.2fK", 2*i+1, current, temp_list(i)));
end

master.coil.off();
