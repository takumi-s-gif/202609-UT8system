classdef BaslerCamera < handle
    
    properties
        src
    end
    properties (Transient)
        vid
    end

    methods
        % connect camera
        function obj = BaslerCamera() 
            imaqreset;

            info = imaqhwinfo('gentl');

            if isempty(info.DeviceIDs)
                error('Camera not found.')
            end

            obj.vid = videoinput('gentl', 1, 'Mono12');
            obj.src = getselectedsource(obj.vid);

            obj.vid.PreviewFullBitDepth = 'on';

            % MATLAB側設定
            triggerconfig(obj.vid, 'hardware', 'DeviceSpecific', 'DeviceSpecific');
            obj.vid.FramesPerTrigger = 1;
            obj.vid.TriggerRepeat = Inf;
            
            % BaslerCamera側設定
            obj.src.TriggerSelector = 'FrameStart';
            obj.src.TriggerSource = 'Software';
            obj.src.TriggerMode = 'On';

            obj.src.BinningHorizontal = 1;
            obj.src.BinningVertical = 1;
            obj.src.BinningHorizontalMode = 'Average';
            obj.src.BinningVerticalMode = 'Average';

            start(obj.vid);

            fprintf('Camera connected. \n');
        end

        % Exposure time
        function exposure_us(obj, exposuretime)
            obj.src.ExposureTime = exposuretime;

            fprintf('Exposuretime = %.0f us. \n', exposuretime);
        end

        % snapshot
        function img = snapshot(obj, Nloop)
            validateattributes(Nloop, {'double', 'single'}, ...
                {'scalar', 'real', 'finite', 'integer', 'positive'}, ...
                'BaslerCamera.snapshot', 'Nloop');

            % preview/ROIで解除したトリガー設定は、撮影時に復元する。
            if ~strcmp(obj.vid.TriggerType, 'hardware') || ...
                    strcmp(obj.src.TriggerMode, 'Off')
                obj.triggermode_on(Nloop);
            end

            % 撮影モードでの枚数不一致は、再設定で隠さずエラーにする。
            framesPerTrigger = obj.vid.FramesPerTrigger;
            if strcmp(obj.src.TriggerSelector, 'FrameBurstStart')
                framesPerCommand = obj.src.AcquisitionBurstFrameCount;
            else
                % コンストラクターで設定するFrameStartは1トリガー1枚。
                framesPerCommand = 1;
            end

            if Nloop ~= framesPerTrigger || Nloop ~= framesPerCommand
                error('BaslerCamera:FrameCountMismatch', ...
                    ['Requested %g frames, but FramesPerTrigger is %g ' ...
                     'and the camera is configured for %g frames per trigger. ' ...
                     'Call triggermode_on(%g) before snapshot(%g).'], ...
                    Nloop, framesPerTrigger, framesPerCommand, Nloop, Nloop);
            end

            executeCommand(obj.src, 'TriggerSoftware');
            imgs = getdata(obj.vid, Nloop);
            img = squeeze( sum(uint32(imgs), 4) );
        end

        % preview
        function preview(obj)
            obj.triggermode_off(); %:triggerMode = onでpreviewすると何故か16bitでサチる
            closepreview(obj.vid);

            img = getsnapshot(obj.vid); %この行があるとトリガーモードと競合するかもしれない、消すとpreviewがおかしくなる。

            ax = axes(figure);
            hImage = image(ax, zeros(1));
            preview(obj.vid, hImage);

            hImage.CDataMapping = 'scaled';
            axis(ax, 'image');
            colormap(ax, "parula");
            colorbar(ax);
            clim(ax, 'auto');
            % clim(ax, [0 4095]);

            drawnow;
        end

        function triggermode_on(obj, Nloop)
            % Runningがoffでもプレビューは動作し得るため、先に停止する。
            stoppreview(obj.vid);

            % 動作中なら一度止める
            if strcmp(obj.vid.Running, 'on')
                stop(obj.vid);
            end
        
            % MATLAB側を先にhardware trigger設定
            triggerconfig(obj.vid, 'hardware', 'DeviceSpecific', 'DeviceSpecific');
            obj.vid.FramesPerTrigger = Nloop;
            obj.vid.TriggerRepeat = Inf;
        
            % BaslerCamera側
            % Frame triggerも明示的にOFF
            obj.src.TriggerSelector = 'FrameStart';
            obj.src.TriggerMode = 'Off';

            obj.src.TriggerSelector = 'FrameBurstStart';
            obj.src.TriggerSource = 'Software';
            obj.src.TriggerMode = 'On';


            obj.src.AcquisitionBurstFrameCount = Nloop;
        
            flushdata(obj.vid);
            start(obj.vid);
        end

        function triggermode_off(obj)
            % ROI変更やトリガー設定の変更前にプレビューも停止する。
            stoppreview(obj.vid);

            if strcmp(obj.vid.Running, 'on')
                stop(obj.vid);
            end
        
            % Burst triggerをOFF
            obj.src.TriggerSelector = 'FrameBurstStart';
            obj.src.TriggerMode = 'Off';
        
            % Frame triggerも明示的にOFF
            obj.src.TriggerSelector = 'FrameStart';
            obj.src.TriggerMode = 'Off';
        
            % MATLAB側
            triggerconfig(obj.vid, 'immediate');
        
            flushdata(obj.vid);
        end

        % cameraオブジェクトを解放
        function delete(obj)
            delete(obj.vid);
        end

        % ROIの設定
        function ROI(obj, roiXOffset, roiYOffset, roiWidth, roiHeight)
            obj.triggermode_off();

            DefaultWidth = double(2064 / obj.src.BinningHorizontal);
            DefaultHeight = double(1544 / obj.src.BinningVertical);

            roiXOffset = roiXOffset * DefaultWidth;
            roiYOffset = roiYOffset * DefaultHeight;
            roiWidth = roiWidth * DefaultWidth;
            roiHeight = roiHeight * DefaultHeight;

            obj.vid.ROIPosition = [roiXOffset, roiYOffset, roiWidth, roiHeight];
        end
    end
end