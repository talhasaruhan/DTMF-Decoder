function u16 = ReadU16(s)
c1 = uint16(ReadU8(s));
c0 = uint16(ReadU8(s));
u16 = c0 * 256 + c1;
end

