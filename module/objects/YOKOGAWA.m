classdef YOKOGAWA < handle

    properties
        coil
    end

    methods
        % connect YOKOGAWA
        function obj = YOKOGAWA()
            obj.coil = visadev("GPIB0::2::INSTR");
        end

        % YOKOGAWAの解放
        function delete(obj)
            delete(obj.coil);
        end

        % current on
        function on(obj)
            writeline(obj.coil, "O1;E");
        end

        % current off
        function off(obj)
            writeline(obj.coil, "O0;E");
        end

        % set output current
        function current_A(obj, current)
            writeline(obj.coil, sprintf("S%.4f;E", current));
        end
    end

end