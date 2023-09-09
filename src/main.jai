test_cipher :: (name: string, func: Cipher, param: Options, expected: string) {
	print_res := (func: string, opts: Options, res: string) {
		print("%(%) = %\n", func, opts, res);
	}

	res := func(param);
	print_res(name, param, res);
	assert(res == expected);
	print("SUCCESS: % - %\n", name, param.mode);
}

main :: () {
	table : Table(string, Cipher);
	init(*table);

	// Generated in build.jai
	add_ciphers_to_table(*table);

	
	for table {
		enc_opts: Options;
		dec_opts: Options;
		if it_index == {
			case "rot13";
			enc_opts = Options.{
				mode = .ENCODE,
				inp = "Hello, World!"
			};
			dec_opts = Options.{
				mode = .DECODE,
				inp = "Uryyb, Jbeyq!"
			};
			
			case "caesar";
			enc_opts = Options.{
				mode = .ENCODE,
				key_type = .INT,
				key_int = 19,
				inp = "Hello, World!"
			};
			dec_opts = Options.{
				mode = .DECODE,
				key_type = .INT,
				key_int = 19,
				inp = "Axeeh, Phkew!"
			};

			case "xor";
			enc_opts = Options.{
				mode = .ENCODE,
				inp = "Hello, World!",
				key_type = .HEX,
				key_string = "0F",
			};
			dec_opts = Options.{
				mode = .DECODE,
				inp = "Gjcc`#/X`}ck.",
				key_type = .HEX,
				key_string = "0F",
			};

			case "hex";
			enc_opts = Options.{
				mode = .ENCODE,
				inp = "Hello, World!",
			};
			dec_opts = Options.{
				mode = .DECODE,
				inp = "48656c6c6f2c20576f726c6421",
			};
		}
		print("%:\n", it_index);
		test_cipher(it_index, it, enc_opts, dec_opts.inp);
		test_cipher(it_index, it, dec_opts, enc_opts.inp);
		print("\n");
	}
}

#import "Hash_Table";
#import "Basic";

#load "ciphers.jai";
