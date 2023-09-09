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
					inp = "Hello, World!"
				},
				"Uryyb, Jbeyq!"
			);
			
			case "caesar";
			test_cipher(
				it_index,
				it,
				Options.{
					key_type = .INT,
					key_int = 19,
					inp = "Hello, World!"
				},
				"Axeeh, Phkew!"
			);

			case "xor";
			test_cipher(
				it_index,
				it,
				Options.{
					inp = "Hello, World!",
					key_type = .HEX,
					key_string = "0F",
				},
				"Gjcc`#/X`}ck.",
			);

			case "hex";
			test_cipher(
				it_index,
				it,
				Options.{
					inp = "Hello, World!",
				},
				"48656c6c6f2c20576f726c6421"
			);
		}
	}
}

#import "Hash_Table";
#import "Basic";

#load "ciphers.jai";
