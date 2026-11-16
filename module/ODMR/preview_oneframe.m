function preview_oneframe(camera)
camera.vid.PreviewFullBitDepth = 'on';

img = getsnapshot(camera.vid);

fig = figure;
ax = axes(fig);
hImage = image(ax, img);

preview(camera.vid,hImage);

hImage.CDataMapping = 'scaled';

axis(ax, 'image');

colormap(ax, "parula");
colorbar(ax);

clim(ax, 'auto');

drawnow;
end