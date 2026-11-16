function take_odmr(camera, Exp_name, data_name)
% Vector Generator との接続
smu = visadev("GPIB0::28::INSTR");
mwCleanup = onCleanup(@() cleanupMW(smu));

% 保存フォルダの作成
month = string(datetime("now", "Format", "yyyyMM"));
day = string(datetime("now", "Format", "MMdd"));
now = string(datetime("now", "Format", "HH-mm-ss"));
data_folder_path = fullfile("\\133.11.161.51\home\Shared Workspace\UT8-system\202609-UT8system\data", month, day + "_" +  Exp_name);
if ~isfolder(data_folder_path)
    mkdir(data_folder_path);
end

% ODMR測定

ODMR = struct();

% MW off
writeline(smu, "OUTP1 OFF")
ODMR.Ref = getsnapshot(camera.vid);

% MW on
MW = struct();
MW.Freq = 2850:2:2910;

writeline(smu, "OUTP1 ON");
writeline(smu, "SOUR1:POW 5dBm");

for i = 1 : size(MW.Freq, 2)
writeline(smu, "SOUR1:FREQ " + MW.Freq(i) + "MHz");
ODMR.Sig(:,:,i) = getsnapshot(camera.vid);
end

% MWのデータ保存
MW.Power_dBm = str2double(writeread(smu, "SOUR1:POW?"));

% 測定後にベクトルジェネレータを安全に停止
writeline(smu, "OUTP1 OFF");
clear smu


% データを struct に入れる
% cam
cam = struct();

cam = get(camera.src);
cam.AcquisitionTime = datetime("now");
cam.ImageHeight_px = size(ODMR.Ref, 1);
cam.ImageWidth_px  = size(ODMR.Sig, 2);

% MISC
MISC = struct();

MISC.data_name = data_name;

% 保存
datapath = fullfile(data_folder_path, now + '_' + data_name + '.mat');
save(datapath, 'cam', 'MW', 'ODMR', 'MISC', '-v7.3');

end

%%
function cleanupCamera(vid)

try
    if strcmp(vid.Running, "on")
        stop(vid);
    end
catch
end

try
    delete(vid);
catch
end

end

%%
function cleanupMW(smu)

try
    writeline(smu, "OUTP1 OFF");
catch
end

end