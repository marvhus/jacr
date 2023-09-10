Cipher :: #type (Options) -> string;

/* template
test :: (inp: string) -> string {
	return inp;
} @cipher
*/

Options :: struct {
	mode: enum {
		ENCODE;
		DECODE;
	}
	inp: string;
	key: string;
}

rot13 :: (using opts: Options) -> string {
	assert(inp != "");
	
	new_opts := Options.{
		mode = mode,
		inp = inp,
		key = "13",
	};

	return caesar(new_opts);
} @cipher

caesar :: (using opts: Options) -> string {
	assert(inp != "");
	key_num, success, _ := to_integer(key);
	assert(success);

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
			//chr += key;
			case .DECODE;
			//chr -= key;
			case;
			assert(false, "Unsupported mode for Caesar");
		}
		chr %= 26;
		// modulo doesn't wrap negative numbers, so we have to do it ourselves
		if chr < 0 then chr = 26 + chr;
		chr += offset;

		array_add(*out, cast,no_check(u8) chr);
	}
	return to_string(out);
} @cipher

xor :: (opts: Options) -> string {
	assert(opts.inp != "");
	key := hex_str_to_u8s(opts.key);
	assert(key.count > 0);
	
	out: [..]u8;
	chr: u8;
	for 0..opts.inp.count-1 {
		chr = opts.inp[it] ^ key[it % key.count];
		array_add(*out, chr);
	}
	return to_string(out);
} @cipher

hex :: (using opts: Options) -> string {
	assert(inp.count > 0);

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
		return to_string(out);

		case .DECODE;
		return to_string(hex_str_to_u8s(inp));
	}

	assert(false, "You forgot to implement that mode for hex");
	return "";
} @cipher

#scope_file

is_upper :: (chr: u8) -> bool {
	return chr >= #char "A" && chr <= #char "Z";
}
is_validhex :: (chr: u8) -> bool {
	return (chr >= #char "A" && chr <= #char "F")
		|| (chr >= #char "a" && chr <= #char "f")
		|| (chr >= #char "0" && chr <= #char "9");
}

hex_str_to_u8s :: (inp: string) -> []u8 {
	out: [..]u8;
	counter := inp.count % 2;
	val : u8 = 0;
	for 0..inp.count-1 {
		chr := to_lower(inp[it]);
		assert(is_validhex(chr));
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


