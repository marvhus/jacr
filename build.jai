#run {
	set_build_options_dc(.{do_output=false});

	workspace := compiler_create_workspace("jacr Workspace");
	if !workspace {
		log_error("Failed to create workspace.\n");
		return;
	}

	// Create needed directories if it doesn't exist
	make_directory_if_it_does_not_exist("bin");
	make_directory_if_it_does_not_exist("modules");

	// configure build options
	options := get_build_options(workspace);

	// Set output executable path and name
	options.output_executable_name = "exec";
	options.output_path = "bin/";

	// Add modules folder to import path
	import_path: [..]string;
	array_add(*import_path, tprint("modules/"));
	array_add(*import_path, ..options.import_path);
	options.import_path = import_path;

	set_build_options(options, workspace);

	// Add file to compile
	compiler_begin_intercept(workspace);
	add_build_file(tprint("src/main.jai"), workspace);

	// Gather and add code for functions with @cipher note
	functions: [..]string;
	gen_code := false;
	while true {
		message := compiler_wait_for_message();
		if !message break;

		if message.kind == {
			case .TYPECHECKED;
			typechecked := cast(*Message_Typechecked) message;
			for decl: typechecked.declarations {
				// Ignore main
				if decl.expression.name == "main" continue;

				for note: decl.expression.notes {
					if note.text == "cipher" then array_add(*functions, copy_string(decl.expression.name));
				}
			}

			case .PHASE;
			phase := cast(*Message_Phase) message;
			if !gen_code && phase.phase == .TYPECHECKED_ALL_WE_CAN {
				code := generate_code(functions);
				add_build_string(code, workspace);
				gen_code = true;
			}

			case .COMPLETE;
			break;
		}
	}

	compiler_end_intercept(workspace);
}

generate_code :: (functions: []string) -> string {
	builder: String_Builder;
	append(*builder, "add_ciphers_to_table :: (table: Table(string, Cipher)) {\n");
	for func: functions {
		print_to_builder(*builder, "  table_add(*table, \"%1\", %1);\n", func);
	}
	append(*builder, "}\n");
	return builder_to_string(*builder);
}

#import "Compiler";
#import "String";
#import "Basic";
#import "File";
