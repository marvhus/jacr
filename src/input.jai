
#if OS == .LINUX {
	#import "POSIX";

	input :: () -> string {
		MAX_BYTES_TO_READ :: 4096; // if anyone needs more, just modify it
		buffer: [MAX_BYTES_TO_READ] u8;
		bytes_read := read(STDIN_FILENO, buffer.data, MAX_BYTES_TO_READ-1);
		str := to_string(buffer.data, bytes_read-1); // ignoring the newline at the end
		return copy_string(str);
	}
} else {
	#assert(false); // @TODO support more than linux
}
