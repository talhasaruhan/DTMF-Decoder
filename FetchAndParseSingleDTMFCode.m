function code = FetchAndParseSingleDTMFCode(s, sampling_freq, READ_ANALOG_INPUT_WINDOW_LENGTH, ...
    DTMF_DELTA_LIMIT, DTMF, INVALID, READ_ANALOG_INPUT_REQUEST_FLAG, READ_ANALOG_INPUT_ACK_FLAG, ...
    READ_ANALOG_INPUT_DONE_FLAG)

% Request Analog Input Samples
READ_ANALOG_INPUT_NUM_SAMPLES = round(READ_ANALOG_INPUT_WINDOW_LENGTH * sampling_freq);
samples = RequestAnalogSamples(s, ...
    INVALID, READ_ANALOG_INPUT_REQUEST_FLAG, READ_ANALOG_INPUT_ACK_FLAG, ...
    READ_ANALOG_INPUT_DONE_FLAG, READ_ANALOG_INPUT_NUM_SAMPLES);

% Plot the time domain signal
% plot(samples, '-o');

% Plot the frequency domain representation of the signal
samples_fft = abs(fft(samples));
L = READ_ANALOG_INPUT_NUM_SAMPLES;
samples_fft = samples_fft(1:floor(L/2+1));
samples_fft(2:end-1) = 2*samples_fft(2:end-1);
f = sampling_freq*(0:(L/2))/L;
% plot(f, samples_fft) 

[nnrow, nncol] = FindNearestDTMF(f, samples_fft, L, DTMF_DELTA_LIMIT);
if nnrow < 0 || nncol < 0
    code = 0;
    return;
end
code = DTMF(nnrow, nncol);
end

