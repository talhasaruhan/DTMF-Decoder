function c = ReadI8(s)
c = read(s, 1, "uint8");
if c >= 128
    c = -int8(c-128);
end
end