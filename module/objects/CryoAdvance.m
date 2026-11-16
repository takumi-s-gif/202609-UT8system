classdef CryoAdvance < handle

    properties
        root
        platformInfo %.sample. temperature, temperatureStable
    end

    methods
        % connect CryoAdvance
        function obj = CryoAdvance()
            root = 'http://133.11.161.88:47101/v1';
            obj.root = root;
            obj.platformInfo = webread([obj.root '/sampleChamber/temperatureControllers/platform/thermometer/properties/sample']);
        end

        % set target temperature
        function temperature_K(obj, temperature)
            options_put = weboptions('RequestMethod', 'put');
            data = struct('platformTargetTemperature', temperature);

            webwrite([obj.root '/controller/properties/platformTargetTemperature'], data, options_put);
            obj.status_cooldown();
            
            % stabeになるまで待つ
            pause(10);
            while true
                pause(1);
                reply = webread([obj.root '/sampleChamber/temperatureControllers/platform/thermometer/properties/sample' ]);
                if reply.sample.temperatureStable == 1
                    fprintf("Stable at %.2f K. \n", reply.sample.temperature);
                    break
                end
            end
        end

        % status cooldown
        function status_cooldown(obj)
            options_post = weboptions('RequestMethod', 'post');
            webwrite([obj.root '/controller/methods/cooldown()'], options_post);
        end

        % status warmup
        function warmup(obj)
            options_post = weboptions('RequestMethod', 'post');
            webwrite([obj.root '/controller/methods/warmup()'], options_post);
        end
    end

end