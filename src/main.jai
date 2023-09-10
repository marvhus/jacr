handle_args :: () -> (string, Options) {
	// @TODO add support for getting input from stdin
	args := get_command_line_arguments();

	if args.count < 3 {
		// @NOTE will not checking if args at least has a length of 1 be an issue here?
		print("Expected % <cipher> <input>", args[0]);
		exit(1);
	}

	cipher := args[1];
	opts := Options.{
		mode = .ENCODE,
		inp = args[2],
	};

	idx := 3;
	while idx < args.count {
		arg := args[idx];
		if arg == {
			case "-k";
			// Key, next arg is the key
			if idx+1 < args.count {
				idx += 1;
				opts.key = args[idx];
			} else {
				print("Expected key after '-k'\n");
				exit(1);
			}

			case;
			print("Unexpected arg '%'\n", arg);
			exit(1);
		}

		idx += 1;
	}

	return cipher, opts;
}

main :: () {
	table : Table(string, Cipher);
	init(*table);

	// Generated in build.jai
	add_ciphers_to_table(*table);

	cipher, opts := handle_args();
	success, cipher_func := table_find(*table, cipher);
	if !success {
		print("Unknow cipher '%'\n", cipher);
		exit(1);
	}

	print("%\n", cipher_func(opts));
}

test_ciphers :: (table: Table(string, Cipher)) {
	test_cipher := (name: string, func: Cipher, param: Options, expected: string) {
		print_res := (func: string, opts: Options, res: string) {
			print("%(%) = %\n", func, opts, res);
		}
		
		res := func(param);
		print_res(name, param, res);
		assert(res == expected);
		print("SUCCESS: % - %\n", name, param.mode);
	}
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
				key = "19",
				inp = "Hello, World!"
			};
			dec_opts = Options.{
				mode = .DECODE,
				key = "19",
				inp = "Axeeh, Phkew!"
			};

			case "xor";
			enc_opts = Options.{
				mode = .ENCODE,
				inp = "Hello, World!",
				key = "0F",
			};
			dec_opts = Options.{
				mode = .DECODE,
				inp = "Gjcc`#/X`}ck.",
				key = "0F",
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
