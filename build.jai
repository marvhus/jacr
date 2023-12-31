#run {
    set_build_options_dc(.{do_output=false});
    user_args, compiler_args := get_build_options().compile_time_command_line;

    testing := false;
    for arg: user_args {
        if arg == "test" then testing = true;
    }

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
    add_build_file("src/main.jai", workspace);

    // Add ciphers in ./src/ciphers directory
    files := file_list("./src/ciphers", true);
    for path: files {
        // only include jai source files
        if !ends_with(path, ".jai") continue; 
        add_build_file(path, workspace);
    }

    // Add and set TESTING variable
    add_build_string(tprint("TESTING :: %;\n", testing), workspace);

    // Gather and add code for functions with @cipher note
    // (or with @test note if compiling with tests)
    functions: [..]string;
    gen_code := false;
    desired_note := "cipher";
    if testing then desired_note = "test";

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
                if note.text == desired_note {
                    array_add(*functions, copy_string(decl.expression.name));
                }
            }
        }

        case .PHASE;
        phase := cast(*Message_Phase) message;
        if !gen_code && phase.phase == .TYPECHECKED_ALL_WE_CAN {
            code := generate_code(functions, testing);
            add_build_string(code, workspace);
            gen_code = true;
        }

            case .COMPLETE;
            break;
        }
    }

    compiler_end_intercept(workspace);
}

generate_code :: (functions: []string, testing: bool) -> string {
    builder: String_Builder;
    function_name := ifx testing then "add_tests_to_table" else "add_ciphers_to_table";
    value_type := ifx testing then "Test" else "Cipher";
    print_to_builder(*builder, "% :: (table: Table(string, %)) {\n",
                     function_name, value_type);
    for func: functions {
        print_to_builder(*builder, "  table_add(*table, \"%1\", %1);\n", func);
    }
    append(*builder, "}\n");
    return builder_to_string(*builder);
}

#import "File_Utilities";
#import "Compiler";
#import "String";
#import "Basic";
#import "File";
