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
