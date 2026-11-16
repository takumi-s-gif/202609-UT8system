function src = camera_settings(camera, exposuretime)

camera.src.ExposureAuto = "Off";
camera.src.ExposureTime = exposuretime;

camera.src.GainAuto = "off";
camera.src.Gain = 5;

end