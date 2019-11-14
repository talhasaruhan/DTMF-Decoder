function [closest_row, closest_col] = FindNearestDTMF(f, samples_fft, L, DELTA_LIMIT)
% Now we can do this two ways,
% We can either use FFT and find the peaks then find nearest valid
% DTMF frequencies for those, or we can use a more conventional filter.
% Normally, downsides of using FFT for filtering are:
%   You have to wait to collect all the samples,
%   Even if you break down the signal into windows and use FFT on them,
%       since FFT assumes a periodical signal, after the inverse transform,
%       you'll get horrible artifacts at the window boundaries.
%   It might be more computationally expensive
% However in this application I think it's a good fit because:
%   We can just take 10 ms long windows and process them,
%   and since we're not doing a IFT, we don't care about the periodicity
% Set DTMF configurations
DTMF_COLS = [1209 1336 1477 1633];
DTMF_ROWS = [697 770 852 941];

sorted_fft = sortrows([samples_fft; 1:(L/2+1)]');
peak1 = f(sorted_fft(end, 2));
peak2 = f(sorted_fft(end-1, 2));

closest_row = -1;
closest_col = -1;

[min_val_col1, closest_index_col1] = min(abs(peak1 - DTMF_COLS));
[min_val_row1, closest_index_row1] = min(abs(peak1 - DTMF_ROWS));
if min_val_col1 < min_val_row1
    if min_val_col1 < DELTA_LIMIT
        closest_col = closest_index_col1;
    else
        closest_col = -1;
        closest_row = -1;
        return;
    end
else
    closest_row = closest_index_row1;
end

[min_val_col2, closest_index_col2] = min(abs(peak2 - DTMF_COLS));
[min_val_row2, closest_index_row2] = min(abs(peak2 - DTMF_ROWS));
if min_val_col2 < min_val_row2
    if min_val_col2 < DELTA_LIMIT
        closest_col = closest_index_col2;
    else
        closest_col = -1;
        closest_row = -1;
        return;
    end
else
    closest_row = closest_index_row2;
end
end

