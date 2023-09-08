Cipher :: #type (Options) -> string;

/* template
test :: (inp: string) -> string {
	return inp;
} @cipher
*/

Options :: struct {
	inp: string;
	key: int;
}

rot13 :: (using opts: Options) -> string {
	assert(inp != "");
	
	new_opts: Options;
	new_opts.inp = inp;
	new_opts.key = 13;

	return caesar(new_opts);
} @cipher

caesar :: (using opts: Options) -> string {
	assert(inp != "");

	out: [..]u8;
	chr: s64;
	for 0..inp.count-1 {
		// to prevent overlowing
		chr = cast(s16) inp[it];

		// Ignore non letter characters
		if !is_alpha(cast,no_check(u8) chr) {
			array_add(*out, inp[it]);
			continue;
		}

		offset := ifx is_upper(cast,no_check(u8) chr) then 65 else 97;
		chr += key - offset;
		chr %= 26;
		chr += offset;

		array_add(*out, cast,no_check(u8) chr);
	}
	return to_string(out);
} @cipher

#scope_file

is_upper :: (chr: u8) -> bool {
	return chr >= #char "A" && chr <= #char "Z";
}
