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
	cipher_func, success := table_find(*table, cipher);
	if !success {
		print("Unknow cipher '%'\n", cipher);
		exit(1);
	}

	print("%\n", cipher_func(opts));
}

#import "Hash_Table";
#import "Basic";

#load "ciphers.jai";
