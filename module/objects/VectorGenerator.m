classdef VectorGenerator < handle

    properties
        Freq
        power
        limit
    end
    properties (Transient)
        smu
    end

    methods
        % Vector Generatorとの接続・初期設定
        function obj = VectorGenerator(power_limit_dBm)
            if nargin < 1
                power_limit_dBm = -5;
            end
            obj.smu = visadev("GPIB0::28::INSTR");

            % オフセット・周波数倍率
            writeline(obj.smu, "SOUR1:FREQ:OFFS 0Hz");
            writeline(obj.smu, "SOUR1:FREQ:MULT 1");
            writeline(obj.smu, "SOUR1:POW:OFFS 0dB");

            % 固定周波数・固定電力モード
            writeline(obj.smu, "SOUR1:FREQ:MODE CW");
            writeline(obj.smu, "SOUR1:POW:MODE CW");

            limit = obj.limit_power_dBm(power_limit_dBm);
            obj.limit = limit;
            fprintf("VSG power is limited to %.6f dBm\n", limit);
        end
    
        % RF出力停止・接続解放
        function delete(obj)
            if isempty(obj.smu) || ~isvalid(obj.smu)
                return
            end

            try
                obj.off();
            catch ME
                % OFFに失敗しても接続は解放する
                delete(obj.smu);
                warning('VectorGenerator:ShutdownFailed', ...
                    'RF出力の停止を確認できませんでした: %s', ...
                    ME.message);
                return
            end

            delete(obj.smu);
        end
    
        % MW on
        function on(obj)
            writeline(obj.smu, "OUTP1 ON");
            obj.waitComplete();
        end
    
        % MW off
        function off(obj)
            writeline(obj.smu, "OUTP1 OFF");
            obj.waitComplete();
        end

        % Set Frequency
        function frequency_MHz(obj, frequency)
            writeline(obj.smu, sprintf("SOUR1:FREQ %.6fMHz", frequency) );
            obj.waitComplete();
        end

        % Set MW Power
        function power_dBm(obj, power)
            writeline(obj.smu, sprintf("SOUR1:POW %.6fdBm", power));
            obj.power = power;
            obj.waitComplete();
        end
        
        function limit = limit_power_dBm(obj, power)
            writeline(obj.smu, sprintf("SOUR1:POW:LIM %.6fdBm", power));
            obj.waitComplete();
            limit = str2double(writeread(obj.smu, "SOUR1:POW:LIM?"));
        end
    end

    methods (Access = private)
        % 先行コマンドの処理完了を確認
        function waitComplete(obj)
            response = strtrim(writeread(obj.smu, "*OPC?"));

            if ~strcmp(response, '1')
                error('VectorGenerator:UnexpectedOPCResponse', ...
                    '*OPC? の応答が不正です: %s', response);
            end
        end
    end

end