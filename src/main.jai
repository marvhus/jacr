test_cipher :: (name: string, func: Cipher, param: Options, expected: string) {
	print_res := (func: string, opts: Options, res: string) {
		print("%(%) = %\n", func, opts, res);
	}

	res := func(param);
	print_res(name, param, res);
	assert(res == expected);
	print("SUCCESS: %\n", name);
}

main :: () {
	table : Table(string, Cipher);
	init(*table);

	// Generated in build.jai
	add_ciphers_to_table(*table);

	
	for table {
		if it_index == {
			case "rot13";
			test_cipher(
				it_index,
				it,
				Options.{
					mode = .ENCODE,
					inp = "Hello, World!"
				},
				"Uryyb, Jbeyq!"
			);
			test_cipher(
				it_index,
				it,
				Options.{
					mode = .DECODE,
					inp = "Uryyb, Jbeyq!"
				},
				"Hello, World!"
			);
			
			case "caesar";
			test_cipher(
				it_index,
				it,
				Options.{
					mode = .ENCODE,
					key_type = .INT,
					key_int = 19,
					inp = "Hello, World!"
				},
				"Axeeh, Phkew!"
			);
			test_cipher(
				it_index,
				it,
				Options.{
					mode = .DECODE,
					key_type = .INT,
					key_int = 19,
					inp = "Axeeh, Phkew!"
				},
				"Hello, World!"
			);

			case "xor";
			test_cipher(
				it_index,
				it,
				Options.{
					mode = .ENCODE,
					inp = "Hello, World!",
					key_type = .HEX,
					key_string = "0F",
				},
				"Gjcc`#/X`}ck.",
			);
			test_cipher(
				it_index,
				it,
				Options.{
					mode = .DECODE,
					inp = "Gjcc`#/X`}ck.",
					key_type = .HEX,
					key_string = "0F",
				},
				"Hello, World!",
			);

			case "hex";
			test_cipher(
				it_index,
				it,
				Options.{
					mode = .DECODE,
					inp = "48656c6c6f2c20576f726c6421",
				},
				"Hello, World!"
			);
		}
	}
}

#import "Hash_Table";
#import "Basic";

#load "ciphers.jai";
