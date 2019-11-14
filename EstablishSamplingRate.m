function sampling_freq = EstablishSamplingRate(s, ...
    INVALID, ESTABLISH_SAMPLING_RATE_REQUEST_FLAG, ESTABLISH_SAMPLING_RATE_ACK_FLAG, ...
    ESTABLISH_SAMPLING_RATE_START_DATA_FLAG, ESTABLISH_SAMPLING_RATE_END_DATA_FLAG, ...
    ESTABLISH_SAMPLING_RATE_NUM_TESTS, ESTABLISH_SAMPLING_RATE_NUM_SAMPLES)
%%
% Establish the sampling rate.
% Initialize the request.
byte = "uint8";
signedbyte = "int8";
write(s, ESTABLISH_SAMPLING_RATE_REQUEST_FLAG, byte);
write(s, ESTABLISH_SAMPLING_RATE_NUM_TESTS, byte);
write(s, ESTABLISH_SAMPLING_RATE_NUM_SAMPLES, byte);
nt = SafeReadU8(s, INVALID);
ns = SafeReadU8(s, INVALID);
assert(nt == ESTABLISH_SAMPLING_RATE_NUM_TESTS);
assert(ns == ESTABLISH_SAMPLING_RATE_NUM_SAMPLES);
c = SafeReadU8(s, INVALID);
assert(c == ESTABLISH_SAMPLING_RATE_ACK_FLAG);
%%
% Since we're simulating actual data transfer,
% read and discard these samples
while c ~= ESTABLISH_SAMPLING_RATE_START_DATA_FLAG
    c = ReadU8(s);
end
%%
% Make sure the metadata is correct
assert(c == ESTABLISH_SAMPLING_RATE_START_DATA_FLAG);
num_tests = SafeReadU8(s, INVALID);
num_samples = SafeReadU8(s, INVALID);

assert(num_tests == ESTABLISH_SAMPLING_RATE_NUM_TESTS);
assert(num_samples == ESTABLISH_SAMPLING_RATE_NUM_SAMPLES);
%%
% Read the test timings
test_timings = zeros(1, ESTABLISH_SAMPLING_RATE_NUM_TESTS + 1, "uint32");
for i = 1 : num_tests + 1
    test_timings(i) = ReadU32(s);
end
%%
% Read the end data flag and finalize the sequence
expected_end_flag = SafeReadU8(s, INVALID);
assert(expected_end_flag == ESTABLISH_SAMPLING_RATE_END_DATA_FLAG);

%%
% Calculate the sampling rate
test_timings = diff(test_timings);
avg_sample_period = mean(test_timings) / ESTABLISH_SAMPLING_RATE_NUM_SAMPLES;
sampling_freq = round(1e6 / avg_sample_period);
end

