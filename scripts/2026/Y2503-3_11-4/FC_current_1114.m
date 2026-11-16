clear,clc;
master = Experiment("FC_current");

%%
Freq = 2865:1:2890;
master.MISC.Nloop = 200;

%%
stop(master.camera.vid);
master.camera.vid.Timeout = 60;

%%
master.camera.ROI(0.1,0.2,0.7,0.7);

%%
master.MW.off();
master.coil.off();

current_list = [6e-3, 11e-3, 16e-3];

for i = 1:size(current_list,2)
    master.cryo.temperature_K(90);

    master.coil.current_A( current_list(i) );
    master.coil.on();

    master.cryo.temperature_K(50);

    for j = 1:5
        master.odmr(Freq, sprintf("ID0%02d__I%.4fAFC_T%.2fK", j, current_list(i), 50) );
    end
end