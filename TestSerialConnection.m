function TestSerialConnection(s, INVALID)
byte = "uint8";
% Make sure the buffer is clear by removing any present data
while s.NumBytesAvailable > 0
    read(s, 1, byte);
end
%%
% Make sure the client correctly responds to INVALID requests
write(s, 67, byte);
c = read(s, 1, byte);
assert(c == INVALID);
f = read(s, 1, byte);
assert(f == 67);
end

