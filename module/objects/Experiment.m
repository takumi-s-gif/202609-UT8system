classdef Experiment < handle

    properties
        camera
        MW
        ODMR = struct()
        path
        coil
        cryo
        MISC
    end
    
    methods
        function obj = Experiment(name_exp)
            obj.camera = BaslerCamera();
            obj.MW = VectorGenerator();

            obj.path = PathInfo();
            % pathの作成
            obj.path.path_experiment(name_exp);
            
            obj.coil = YOKOGAWA();
            obj.cryo = CryoAdvance();

            obj.MISC.Nloop = 15;
        end

        % ODMR
        function odmr(obj, Freq, NameData)
            obj.camera.triggermode_on(obj.MISC.Nloop);

            obj.MW.Freq = Freq;

            % Ref
            obj.MW.off();
            obj.ODMR = struct();

            % Ref
            obj.ODMR.Ref = obj.camera.snapshot(obj.MISC.Nloop);

            % Sig
            obj.MW.on();

            nFreq = numel(Freq);
            obj.ODMR.Sig = zeros( ...
                [size(obj.ODMR.Ref), nFreq], ...
                'like', obj.ODMR.Ref);
            for i = 1:nFreq
                obj.MW.frequency_MHz(Freq(i));
                obj.ODMR.Sig(:,:,i) = obj.camera.snapshot(obj.MISC.Nloop);
            end

            % MW off
            obj.MW.off();

            % Experiment.save_data()
            obj.save_data(NameData);
        end

        % save data
        function save_data(obj, NameData)
            % dataのパス作成
            obj.path.path_data(NameData);

            % 保存フォルダの作成
            if ~isfolder(obj.path.PathExp)
                mkdir(obj.path.PathExp);
            end

            cam = struct();
            cam.src = obj.camera.src;
            cam.AcquisitionTime = datetime("now");
            cam.ImageHeight_px = size(obj.ODMR.Ref, 1);
            cam.ImageWidth_px = size(obj.ODMR.Ref, 2);

            MW = struct();
            MW.Freq = obj.MW.Freq;
            MW.power = obj.MW.power;

            ODMR = struct();
            ODMR.Ref = obj.ODMR.Ref;
            ODMR.Sig = obj.ODMR.Sig;

            path = struct();
            path.NameExp = obj.path.NameExp;
            path.PathExp = obj.path.PathExp;
            path.NameData = obj.path.NameData;
            path.PathData = obj.path.PathData;

            save(obj.path.PathData, 'cam', 'MW', 'ODMR', 'path', '-v7.3');
        end

        % show odmr
        function show_odmr(obj)
            Ref = obj.ODMR.Ref;
            Sig = obj.ODMR.Sig;

            n_data = size(Sig, 3);

            contrast = zeros(size(Sig));
            mean_contrast = zeros(1, n_data);

            for i = 1:n_data
                contrast(:,:,i) = double(Sig(:,:,i)) ./ double(Ref);
                contrast(~isfinite(contrast)) = NaN;
                mean_contrast(i) = mean(contrast(:,:,i), 'all', 'omitnan');
            end


            figure;
            plot(obj.MW.Freq, mean_contrast, 'o-');

            xlabel('Frequency (MHz)');
            ylabel('Mean Contrast (a.u.)');
            title(obj.path.NameData, 'Interpreter', 'none');
        end
    end

end