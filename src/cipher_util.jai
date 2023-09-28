is_upper :: (chr: u8) -> bool {
	return chr >= #char "A" && chr <= #char "Z";
}
is_validhex :: (chr: u8) -> bool {
	return (chr >= #char "A" && chr <= #char "F")
		|| (chr >= #char "a" && chr <= #char "f")
		|| (chr >= #char "0" && chr <= #char "9");
}

hex_str_to_u8s :: (inp: string) -> []u8 {
    // @NOTE Caller function handles invalid/empty hex.
    if inp.count == 0 return .[]; 
	out: [..]u8;
	counter := inp.count % 2;
	val : u8 = 0;
	for 0..inp.count-1 {
		chr := to_lower(inp[it]);
        // @NOTE Caller function handles invalid/empty hex.
        if !is_validhex(chr) return .[]; 
		if it != 0 && counter == 0 {
			array_add(*out, val);
			val = 0;
		}
		// chars are checked earlier, it's guaranteed to be alpha or num
		chr_num := ifx is_alpha(chr) then #char "a" - 10 else #char "0";
		chr_num = chr - chr_num;
		if counter == 0 then chr_num *= 16;
		val += cast,no_check(u8) chr_num;

		counter += 1;
		counter %= 2;
	}
	array_add(*out, val);

	return out;
}

// @TODO maybe add a separate one for "Empty text input", it may be handy, since I am repeating it a lot.
check_error :: (condition: bool, message: string, opts: Options) -> bool {
    if condition return false;
    print("[ERROR] '%' with options %\n", message, opts); 
	return true;
}
