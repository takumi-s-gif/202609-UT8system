clear,clc;
master = Experiment("FC");

%%
temp_list = [90 80];
Freq = 2850:2:2910;

master.MW.off();
master.coil.off();

%%
master.coil.on();

master.cryo.temperature_K(90);
current = 0;
master.coil.current_A(current);
master.odmr(Freq, sprintf("ID01__I%.4fA_T%.2fK", current, 90));

current = 0.020;
master.coil.current_A(current);
master.odmr(Freq, sprintf("ID02__I%.4fA_T%.2fK", current, 90));

master.cryo.temperature_K(60);
master.odmr(Freq, sprintf("ID03__I%.4fA_T%.2fK", current, 60));

master.coil.off();