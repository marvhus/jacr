Cipher :: #type (Options) -> bool, string;

Options :: struct {
    mode: enum {
        ENCODE;
        DECODE;
    }
    inp: string = "";
    key: string = "";
}

/* template
test :: (inp: string) -> bool, string {
	return inp;
} @cipher
*/
// place the cipher in a file in jacr/src/ciphers/
