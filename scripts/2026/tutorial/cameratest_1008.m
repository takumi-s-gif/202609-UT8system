imaqreset;

info = imaqhwinfo('gentl');

if isempty(info.DeviceIDs)
    error(['GenTLカメラが見つかりません。' ...
        ' pylon Viewerを閉じ、USB接続を確認してください。']);
end

vid = videoinput('gentl', 1, 'Mono12');

%%
img = getsnapshot(vid);

figure
imagesc(img)
axis image
% colormap gray
colorbar

fprintf("min  = %g\n", min(img(:)));
fprintf("max  = %g\n", max(img(:)));
fprintf("mean = %g\n", mean(double(img(:))));

%%
src = getselectedsource(vid);

src.ExposureAuto = "Off";
src.ExposureTime = 50000;

src.GainAuto = "off";
src.Gain = 5;

%%
vid.PreviewFullBitDepth = 'on';

img = getsnapshot(vid);

fig = figure;
ax = axes(fig);
hImage = image(ax, img);

preview(vid,hImage);

hImage.CDataMapping = 'scaled';

axis(ax, 'image');

colormap(ax, "parula");
colorbar(ax);

clim(ax, 'auto');

drawnow;