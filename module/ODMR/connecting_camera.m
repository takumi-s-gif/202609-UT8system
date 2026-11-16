function camera = connecting_camera()
imaqreset;

info = imaqhwinfo('gentl');

if isempty(info.DeviceIDs)
    error(['GenTLカメラが見つかりません。' ...
        ' pylon Viewerを閉じ、USB接続を確認してください。']);
end

vid = videoinput('gentl', 1, 'Mono12');
src = getselectedsource(vid);

camera.vid = vid;
camera.src = src;

% cleanupObj = onCleanup(@() cleanupCamera(vid));
end


function cleanupCamera(vid)
    try

        if isvalid(vid)

            if strcmp(vid.Running, 'on')
                stop(vid);
            end

            delete(vid);

        end

    catch
    end
end