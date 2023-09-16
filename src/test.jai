test_ciphers :: (table: Table(string, Cipher)) {
    test_cipher := (name: string, func: Cipher, param: Options, expected: string) {
        print_res := (func: string, opts: Options, res: string) {
            print("%(%) = %\n", func, opts, res);
        }

        success, res := func(param);
        if !success {
            print("[FAILURE] Cipher exited with failure % - %",
                name, param.mode);
            return;
        }
        print_res(name, param, res);
        if res != expected {
            print("[FAILIURE] Wrong result for % - %", 
                name, param.mode);
            return;
        }
        print("[SUCCESS] % - %\n", name, param.mode);
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
