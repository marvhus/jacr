xor :: (opts: Options) -> bool, string {
    failed := check_error(opts.inp.count > 0, "No text input", opts);
    failed |= check_error(opts.key.count > 0, "Empty hex key", opts);
    if failed return (false, "");
    key := hex_str_to_u8s(opts.key);
    failed |= check_error(key.count > 0, "Invalid hex key", opts);
    if failed return (false, "");

    out: [..]u8;
    chr: u8;
    for 0..opts.inp.count-1 {
        chr = opts.inp[it] ^ key[it % key.count];
        array_add(*out, chr);
    }
    return (true, to_string(out));
} @cipher

#if TESTING {
xor_test :: () -> u16 {
    failed: u16;
    decoded := "Hello, World!";
    encoded := "Gjcc`#/X`}ck.";

    success, resp := xor(.{
        mode = .ENCODE,
        key = "0F",
        inp = decoded,
    });
    success &= resp == encoded;
    print_ok_or_fail(success, "Xor", "Encoding");

    success, resp = xor(.{
        mode = .DECODE,
        key = "0F",
        inp = encoded,
    });
    success &= resp == decoded;
    print_ok_or_fail(success, "Xor", "Decoding");

    return failed;
} @test
}
