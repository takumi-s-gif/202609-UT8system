function temp_stage = temperature_cryo(temp_target)
root = 'http://133.11.161.88:47101/v1';

% stage温度をtemp_targetにするようput
options_put = weboptions( 'RequestMethod' , 'put' );
data = struct ( 'platformTargetTemperature' , temp_target);
reply1 = webwrite([root '/controller/properties/platformTargetTemperature' ], data, options_put);

% cooldown状態にするようpost
options_post = weboptions( 'RequestMethod' , 'post' );
reply2 = webwrite([root '/controller/methods/cooldown()' ], options_post);

% 実際のtemp_stageを取得
pause(10);

while true
pause(1);

reply3 = webread([root '/sampleChamber/temperatureControllers/platform/thermometer/properties/sample' ]);

if reply3.sample.temperatureStable == 1
    temp_stage = reply3.sample.temperature;
    fprintf("Stable at target: %.2f K\n", temp_stage)
    break
end
end

end