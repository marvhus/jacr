to_lower :: (inp: string) -> string {
	out: [..]u8;
	for 0..inp.count-1 {
		array_add(*out, to_lower(inp[it]));
	}
	return to_string(out);
}
