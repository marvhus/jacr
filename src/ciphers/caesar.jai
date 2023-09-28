caesar :: (using opts: Options) -> bool, string {
    failed := check_error(inp.count > 0, "No text input", opts);
    key_num, success, _ := to_integer(key);
    failed |= check_error(success, "Key is not an integer", opts);
    if failed return (false, "");

    out: [..]u8;
    chr: s64;
    for 0..inp.count-1 {
        // to prevent overflowing
        chr = cast(s16) inp[it];

        // Ignore non letter characters
        if !is_alpha(cast,no_check(u8) chr) {
            array_add(*out, inp[it]);
            continue;
        }

        offset := ifx is_upper(cast,no_check(u8) chr) then #char "A" else #char "a";
        chr -= offset;
        if mode == {
            case .ENCODE;
            chr += key_num;
            case .DECODE;
            chr -= key_num;
            case;
            check_error(false, "Unsupported mode for Caesar", opts);
            return (false, "");
        }
        chr %= 26;
        // modulo doesn't wrap negative numbers, so we have to do it ourselves
        if chr < 0 then chr = 26 + chr;
        chr += offset;

        array_add(*out, cast,no_check(u8) chr);
    }
    return (true, to_string(out));
} @cipher
