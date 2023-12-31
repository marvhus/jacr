main :: () {
    // User specified that they want to run the tests
    // (Added in during compile)
    #if TESTING {
        table : Table(string, Test);
        init(*table);

        // Generated in build.jai
        add_tests_to_table(*table);

        test_ciphers(table);
        return;
    } else {
        table : Table(string, Cipher);
        init(*table);

        // Generated in build.jai
        add_ciphers_to_table(*table);

        cipher, opts := handle_args();
        cipher_func, success := table_find(*table, cipher);
        if !success {
            print("Unknown cipher '%'\n", cipher);
            exit(1);
        }

        res: string;
        success, res = cipher_func(opts);
        if !success {
            print("Cipher had errors. Exiting.\n");
            return;
        }

        print("Result | '%'\n", res); 
    }
}

#import "Hash_Table";
#import "Basic";

#load "cipher.jai";
#load "cipher_util.jai";

#if TESTING {
    #load "test.jai";
} else {
    #load "help.jai";
    #load "args.jai";
    #load "util.jai";
}
