function samples = RequestAnalogSamples(s, ...
    INVALID, READ_ANALOG_INPUT_REQUEST_FLAG, READ_ANALOG_INPUT_ACK_FLAG, ...
    READ_ANALOG_INPUT_DONE_FLAG, READ_ANALOG_INPUT_NUM_SAMPLES)
write(s, READ_ANALOG_INPUT_REQUEST_FLAG, "uint8");
c = SafeReadU8(s, INVALID);
assert(c == READ_ANALOG_INPUT_ACK_FLAG);
write(s, bitshift(READ_ANALOG_INPUT_NUM_SAMPLES, -8), "uint8");
write(s, mod(READ_ANALOG_INPUT_NUM_SAMPLES, 256), "uint8");
n = ReadU16(s);
assert(n == READ_ANALOG_INPUT_NUM_SAMPLES);
%%
samples = zeros(1, READ_ANALOG_INPUT_NUM_SAMPLES, "int8");
for i = 1 : READ_ANALOG_INPUT_NUM_SAMPLES
    c = ReadI8(s);
    samples(i) = c;
end
c = SafeReadU8(s, INVALID);
assert(c == READ_ANALOG_INPUT_DONE_FLAG);
end

