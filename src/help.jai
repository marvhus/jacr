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

	-h
	    open the help menu.
		alternative flags/arguments:
		h, help, -help, --help

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
