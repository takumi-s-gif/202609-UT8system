camera = connecting_camera();

%%
exposuretime = 50000;
camera_settings(camera, exposuretime);

%%
preview_oneframe(camera)

%%
data_name = "test";
save_one_frame(camera, data_name);

%%
data_name = "test9_ODMR";
take_odmr(camera, data_name);

%%
data_name = "1014_ODMRtest";
view_odmr(ODMR, MW, data_name);

%%
tic
camera.snapshot();
toc