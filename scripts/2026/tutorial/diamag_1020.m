% GUIから変数をもらう
camera = app.camera;
Exp_name = app.Exp_name;

% 電流源との接続
coil = visadev("GPIB0::2::INSTR");

%%
current = 75; %mA
current_A = current / 1000;

writeline(coil, "S" + current_A + ";E");

%% diamag3
writeline(coil, "O1;E");

temp_list = 75:3:90;

for i = 1:size(temp_list, 2)
    temp_stage = temperature_cryo(temp_list(i));
    temp_stage = sprintf("%.2f", temp_stage);

    data_name = string("ID00" + i + "__" + "I" + current_A + "A" + "_" + "T" + temp_stage + "K");
    take_odmr(camera, Exp_name, data_name);
end

writeline(coil, "O0;E");
clear coil;

%% diamag4
writeline(coil, "O1;E");

temp_list = 75:0.3:78;

for i = 1:size(temp_list, 2)
    temp_stage = temperature_cryo(temp_list(i));
    temp_stage = sprintf("%.2f", temp_stage);

    data_name = string("ID00" + i + "__" + "I" + current_A + "A" + "_" + "T" + temp_stage + "K");
    take_odmr(camera, Exp_name, data_name);
end

writeline(coil, "O0;E");
clear coil;

%% diamag5
writeline(coil, "O1;E");

temp_list = 75:0.3:78;

for i = 1:size(temp_list, 2)
    temp_stage = temperature_cryo(temp_list(i));
    temp_stage = sprintf("%.2f", temp_stage);

    data_name = string("ID00" + i + "__" + "I" + current_A + "A" + "_" + "T" + temp_stage + "K");
    take_odmr(camera, Exp_name, data_name);
end

writeline(coil, "O0;E");
clear coil;

%% diamag6
temp_list = 75:1:85;

% ZFC
temperature_cryo(90);
writeline(coil, "O0;E");

for i = 1:size(temp_list, 2)
    % set temp
    temp_stage = temperature_cryo(temp_list(i));
    temp_stage = sprintf("%.2f", temp_stage);

    data_name = string("ID00" + i + "__" + "I" + current_A + "A" + "_" + "T" + temp_stage + "K");

    % apply magnetic field
    writeline(coil, "O1;E");
    pause(5);

    % ODMR
    take_odmr(camera, Exp_name, data_name);
end

writeline(coil, "O0;E");
clear coil;

%% diamag7
temp_list = 65:1:75;

% ZFC
temp_stage = temperature_cryo(90);
writeline(coil, "O0;E");

data_name = string("ID00" + "0" + "__" + "I" + "0" + "A" + "_" + "T" + temp_stage + "K");
take_odmr(camera, Exp_name, data_name)

for i = 1:size(temp_list, 2)
    % set temp
    temp_stage = temperature_cryo(temp_list(i));
    temp_stage = sprintf("%.2f", temp_stage);

    data_name = string("ID00" + i + "__" + "I" + current_A + "A" + "_" + "T" + temp_stage + "K");

    % apply magnetic field
    writeline(coil, "O1;E");
    pause(5);

    % ODMR
    take_odmr(camera, Exp_name, data_name);
end

writeline(coil, "O0;E");
clear coil;