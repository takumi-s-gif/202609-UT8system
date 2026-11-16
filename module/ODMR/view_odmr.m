function view_odmr(ODMR, MW, MISC)
Ref = ODMR.Ref;
Sig = ODMR.Sig;

n_data = size(Sig, 3);

contrast = zeros(size(Sig));
mean_contrast = zeros(1, n_data);

for i = 1:n_data
    contrast(:,:,i) = double(Sig(:,:,i)) ./ double(Ref);
    contrast(~isfinite(contrast)) = NaN;
    mean_contrast(i) = mean(contrast(:,:,i), 'all', 'omitnan');
end


figure;
plot(MW.Freq, mean_contrast, 'o-');

xlabel('Frequency (MHz)');
ylabel('Mean Contrast (a.u.)');
title(MISC.data_name, 'Interpreter', 'none');

end