Test :: #type () -> u16;

test_ciphers :: (table: Table(string, Test)) {
    total_failed: u64;
    for table {
        print("===== %\n", it_index);
        total_failed += it();
    }
    print("======\n");
    print("% total failed tests\n", total_failed);
}

print_ok_or_fail :: (success: bool, cipher_name: string, mode: string) #expand {
    if success {
        print_color("OK!", color = .GREEN);
    } else {
        print_color("FAIL!", color = .RED);
        `failed += 1;
    }
    print(" ... % % Cipher\n", mode, cipher_name);
}

#import "Print_Color";
