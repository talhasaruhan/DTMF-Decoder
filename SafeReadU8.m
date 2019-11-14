function c = SafeReadU8(s, INVALID)
byte = "uint8";
% while s.NumBytesAvailable < 1; pause(0.1); end
c = read(s, 1, byte);
if c == INVALID
    % while s.NumBytesAvailable < 1; end
    flag = read(s, 1, byte);
    disp(flag);
    assert(0);
end
end

