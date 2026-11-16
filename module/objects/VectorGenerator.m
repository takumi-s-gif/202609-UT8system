classdef VectorGenerator < handle

    properties
        Freq
        power
    end
    properties (Transient)
        smu
    end

    methods
        % connect mw generator
        function obj = VectorGenerator()
            obj.smu = visadev("GPIB0::28::INSTR");
            obj.power = 10;
        end
    
        % Vector Generatorの解放
        function delete(obj)
            delete(obj.smu);
        end
    
        % MW on
        function on(obj)
            writeline(obj.smu, "OUTP1 ON");
        end
    
        % MW off
        function off(obj)
            writeline(obj.smu, "OUTP1 OFF");
        end

        % Set Frequency
        function frequency_MHz(obj, frequency)
            writeline(obj.smu, sprintf("SOUR1:FREQ %.0fMHz", frequency) );
        end

        % Set MW Power
        function power_dBm(obj, power)
            obj.power = power;
            writeline(obj.smu, sprintf("SOUR1:POW %.0fdBm", power) );
        end
    end

end