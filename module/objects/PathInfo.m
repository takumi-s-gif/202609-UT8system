classdef PathInfo < handle

    properties
        NameExp
        PathExp
        NameData
        PathData
    end

    methods
        % 
        function obj = PathInfo()
        end

        % path of Experiment folder
        function path_experiment(obj, name_exp)
            month = string(datetime("now", "Format", "yyyyMM"));
            day = string(datetime("now", "Format", "MMdd"));

            obj.NameExp = name_exp;
            obj.PathExp = fullfile("\\133.11.161.51\home\Shared Workspace\UT8-system\202609-UT8system\data", month, day + "_" + name_exp);
        end

        % path of data file
        function path_data(obj, name_data)
            now = string(datetime("now", "Format", "HH-mm-ss"));

            obj.NameData = name_data;
            obj.PathData = fullfile(obj.PathExp, now + '_' + name_data + '.mat');
        end
    end

end