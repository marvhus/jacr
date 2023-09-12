help_menu :: () {
    // @TODO find a way to dynamically add ciphers so that I don't have to update this every time
    print(#string END_MESSAGE

Usage: jacr <mode> <cipher> [options]

Modes:

    encrypt
        encrypts the input
        aliases: e, enc, encode

    decrypt
        decrypts the input
        aliases: d, dec, decode

Ciphers:

    rot13
        encrypt/decrypt using the rot13 ciper.
        only text input is required for this.

    caesar
        encrypt/decrypt usng the caesar cipher.
        you need text input, and a integer key (shift).

    xor
        encrypt/decrypt using the xor cipher.
        you need text input, and a hex key (hex encoded bytes).

    hex
        encrypt/decrypt hex.
        only text input is required for this.

Options:

    -i
        text input used by the cipher.
        pass a string of text after this to specify the text input.

    -k
        the key used by the cipher.
        pass a string of text after this to specify the key.
        what is required to be in the key changes depending on the cipher.

Examples:

    jacr e rot13 -i 'Hello, World!'
    jacr d rot13 -i 'Uryyb, Jbeyq!'

    jacr e caesar -i 'Hello, World!' -k 16
    jacr d caesar -i 'Xubbe, Mehbt!' -k 16

    jacr e xor -i 'Hello, World!' -k 0F
    jacr d xor -i 'Gjcc`#/X`}ck.' -k 0F

    jacr e hex -i 'Hello, World!'
    jacr d hex -i '48656c6c6f2c20576f726c6421'

    END_MESSAGE);
}

handle_args :: () -> (string, Options) {
	args := get_command_line_arguments();

    // Check if user is requesting help menu.
    if args.count >= 2 if to_lower(args[1]) == {
        case "h"; #through;
        case "-h"; #through;
        case "help"; #through;
        case "-help"; #through;
        case "--help";
        help_menu();
        exit(1);
    }

	if args.count < 3 {
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
