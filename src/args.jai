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
        print("For a full list of what you can do use the -h argument first\n");
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

    return cipher, opts;
}
