rot13 :: (using opts: Options) -> bool, string {
    failed := check_error(inp.count > 0, "No text input", opts);
    if failed return (false, "");

    new_opts := Options.{
        mode = mode,
        inp = inp,
        key = "13",
    };

    success, res := caesar(new_opts);
    return success, res;
} @cipher

#if TESTING {
rot13_test :: () -> u16 {
    failed: u16;
    decoded := "Hello, World!";
    encoded := "Uryyb, Jbeyq!";

    success, resp := rot13(.{
        mode = .ENCODE,
        inp = decoded,
    });
    success &= resp == encoded;
    print_ok_or_fail(success, "Rot13", "Encoding");

    success, resp = rot13(.{
        mode = .DECODE,
        inp = encoded,
    });
    success &= resp == decoded;
    print_ok_or_fail(success, "Rot13", "Decoding");

    return failed;
} @test
}
