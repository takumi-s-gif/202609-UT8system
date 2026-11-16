% GUIから変数をもらう
camera = app.camera;
Exp_name = app.Exp_name;

%%
% 電流源との接続
coil = visadev("GPIB0::2::INSTR");

%%
% 電流設定
writeline(coil, "O0;E");
writeline(coil, "S0.006;E"); % A
% writeline(coil,"O1;E");

current = writeread(coil, "OD;E");

%%
% 磁場掃引
current_list = 0:15:75; % mA
current_list_A = current_list / 1000;

%%
writeline(coil, "O1;E"); %yokogawa on

for i = 1:length(current_list_A)
    I = current_list_A(i);

    writeline(coil, "S" + I + ";E");
    pause(1); % s
    
    data_name = string("ID00" + i + "__" + "I" + I + "A");

    take_odmr(camera, Exp_name, data_name);
end

writeline(coil, "O0;E"); % yokogawa off
clear coil;