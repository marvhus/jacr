hex :: (using opts: Options) -> bool, string {
    failed := check_error(inp.count > 0, "No text input", opts);
    if failed return (false, "");

    if mode == {
        case .ENCODE;
        // This feels a little like cheating, but it works
        chrs :: u8.[
            #char "0", #char "1", #char "2", #char "3",
            #char "4", #char "5", #char "6", #char "7",
            #char "8", #char "9", #char "a", #char "b",
            #char "c", #char "d", #char "e", #char "f",
        ];
        out: [..]u8;
        counter := 0;
        for 0..inp.count-1 {
            chr := inp[it];
            first := (chr & 0xf0) >> 4;
            last  := chr & 0x0f;
            array_add(*out, chrs[first]);
            array_add(*out, chrs[last]);
        }
        return (true, to_string(out));

        case .DECODE;
        hex := hex_str_to_u8s(inp);
        failed |= check_error(hex.count > 0, "Invalid hex input", opts);
        if failed return (false, "");
        return (true, to_string(hex));
    }

    check_error(false, "Unimplemented mode for hex", opts);
    return (false, "");
} @cipher

#if TESTING {
hex_test :: () -> u16 {
    failed: u16;
    decoded := "Hello, World!";
    encoded := "48656c6c6f2c20576f726c6421";

    success, resp := hex(.{
        mode = .ENCODE,
        inp = decoded,
    });
    success &= resp == encoded;
    print_ok_or_fail(success, "Hex", "Encoding");

    success, resp = hex(.{
        mode = .DECODE,
        inp = encoded,
    });
    success &= resp == decoded;
    print_ok_or_fail(success, "Hex", "Decoding");

    return failed;
} @test
}
