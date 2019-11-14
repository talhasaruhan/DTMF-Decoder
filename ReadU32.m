function u32 = ReadU32(s)
c3 = uint32(ReadU8(s));
c2 = uint32(ReadU8(s));
c1 = uint32(ReadU8(s));
c0 = uint32(ReadU8(s));
u32 = c0 * 256 * 256 * 256 + c1 * 256 * 256 + c2 * 256 + c3;
end

