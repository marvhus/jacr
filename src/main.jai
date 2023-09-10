handle_args :: () -> (string, Options) {
	args := get_command_line_arguments();

	if args.count < 4 {
		// @NOTE will not checking if args at least has a length of 1 be an issue here?
		print("Expected % <mode> <cipher>\n", args[0]);
		exit(1);
	}

	cipher := args[2];
	opts: Options;
	if to_lower(args[1]) == {
		case "e"; #through;
		case "enc"; #through;
		case "encode"; #through;
		case "encrypt";
		opts.mode = .ENCODE;

		case "d"; #through;
		case "dec"; #through;
		case "decode"; #through;
		case "decrypt";
		opts.mode = .DECODE;

		case;
		print("Unknown mode '%'\n", args[1]);
		exit(1);
	}

	found_inp := false;
	idx := 3;
	while idx < args.count {
		arg := args[idx];
		if arg == {
			case "-i";
			// Inp, next arg is the input
			idx += 1;
			if idx >= args.count {
				print("Expected input after '-i'\n");
				exit(1);
			}
			opts.inp = args[idx];
			found_inp = true;
			
			case "-k";
			// Key, next arg is the key
			idx += 1;
			if idx >= args.count {
				print("Expected key after '-k'\n");
				exit(1);
			}
			opts.key = args[idx];

			case;
			print("Unexpected arg '%'\n", arg);
			exit(1);
		}

		idx += 1;
	}
	
	// Blocking Console Input (used for | support)
	if !found_inp then opts.inp = input(); 

	return cipher, opts;
}

to_lower :: (inp: string) -> string {
	out: [..]u8;
	for 0..inp.count-1 {
		array_add(*out, to_lower(inp[it]));
	}
	return to_string(out);
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
#load "input.jai";
