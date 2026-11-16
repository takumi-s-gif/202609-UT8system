clear,clc;
master = Experiment("FC");

%%
Freq = [2855:5:2865 2866 2867 2867.5:0.5:2872.5 2873:1:2882 2882.5:0.5:2887.5 2888 2889 2890:5:2900];

master.MW.off();

master.coil.current_A(0);
master.coil.off();

%%
master.coil.on();

master.cryo.temperature_K(100);
current = 0;

master.coil.current_A(current);
master.odmr(Freq, sprintf("ID01__I%.4fA_T%.2fK", current, 100));

current = 0.015;
master.coil.current_A(current);
master.odmr(Freq, sprintf("ID02__I%.4fA_T%.2fK", current, 100));

master.cryo.temperature_K(60);
master.odmr(Freq, sprintf("ID03__I%.4fA_T%.2fK", current, 60));

master.coil.off();

%%
Freq = [2850:2:2870  2871:1:2889  2890:2:2910];

master.MW.off();

%%
master.cryo.temperature_K(60);
current = 0.015;
master.odmr(Freq, sprintf("ID01__I%.4fA_T%.2fK", current, 60));

master.coil.off();