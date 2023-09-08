main :: () {
	table : Table(string, Cipher);
	init(*table);

	// Generated in build.jai
	add_ciphers_to_table(*table);

	print_res := (func: string, opts: Options, res: string) {
		print("%(%) = %\n", func, opts, res);
	}
	
	for cipher: table {
		if it_index == {
			case "rot13";
			opts := Options.{
				inp = "Hello, World!",
			};
			res := cipher(opts);
			print_res(it_index, opts, res);
			assert(res == "Uryyb, Jbeyq!");
			
			case "caesar";
			opts := Options.{
				inp = "Hello, World!",
				key = 19,
			};
			res := cipher(opts);
			print_res(it_index, opts, res);
			assert(res == "Axeeh, Phkew!");
		}
	}
}

#import "Hash_Table";
#import "Basic";

#load "ciphers.jai";
