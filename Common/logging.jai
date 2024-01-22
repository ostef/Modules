#add_context log_section : *Log_Section;

LogSectionScope :: (section : *Log_Section) #expand
{
    prev := context.log_section;
    context.log_section = section;
    `defer context.log_section = prev;
}

LoggerScope :: (data : *void, proc : Logger) #expand
{
    prev_data := context.logger_data;
    prev_logger := context.logger;

    context.logger_data = data;
    context.logger = proc;

    `defer context.logger_data = prev_data;
    `defer context.logger = prev_logger;
}

SetContextLogger :: inline (data : *void, proc : Logger)
{
    context.logger_data = data;
    context.logger = proc;
}

ConsoleLogger :: struct
{
    report_filenames := false;
    print_colors := false;
}

None_Color_Str    :: "\x1b[0m";
Info_Color_Str    :: "\x1b[1;32m";
Warning_Color_Str :: "\x1b[1;33m";
Error_Color_Str   :: "\x1b[1;31m";
Fatal_Color_Str   :: "\x1b[1;35m";

ConsoleColor :: enum
{
    None;
    Info;
    Warning;
    Error;
    Fatal;
}

SetConsoleColor :: (color : ConsoleColor, to_standard_error := true)
{
    if #complete color ==
    {
    case .None;
        write_string (None_Color_Str, to_standard_error = to_standard_error);
    case .Info;
        write_string (Info_Color_Str, to_standard_error = to_standard_error);
    case .Warning;
        write_string (Warning_Color_Str, to_standard_error = to_standard_error);
    case .Error;
        write_string (Error_Color_Str, to_standard_error = to_standard_error);
    case .Fatal;
        write_string (Fatal_Color_Str, to_standard_error = to_standard_error);
    }
}

ConsoleLoggerProc :: (message : string, data : *void, info : Log_Info)
{
    if !message
        return;

    if info.common_flags & .TO_FILE_ONLY
        return;

    if context.log_level == .NORMAL
    && (info.common_flags & .VERBOSE_ONLY || info.common_flags & .VERY_VERBOSE_ONLY)
    {
        return;
    }

    if context.log_level == .VERBOSE
    && info.common_flags & .VERY_VERBOSE_ONLY
    {
        return;
    }

    using logger := cast (*ConsoleLogger) data;

    builder : StringBuilder;
    builder.allocator = Temp;

    if info.section
        StringBuilderAppend (*builder, "[%] ", info.section.name);

    // @Todo: reduce filename
    if report_filenames
        StringBuilderAppend (*builder, "(%:%) ", info.location.fully_pathed_filename, info.location.line_number);

    StringBuilderAppend (*builder, message);

    if message[message.count - 1] != #char "\n"
        StringBuilderAppend (*builder, "\n");

    str := StringBuilderBuild (*builder,, Temp);

    to_stderr := (info.common_flags | .ERROR) != 0;

    if print_colors
    {
        if info.common_flags & .ERROR
            SetConsoleColor (.Error, to_standard_error = to_stderr);
        else if info.common_flags & .WARNING
            SetConsoleColor (.Warning, to_standard_error = to_stderr);
    }

    write_string (str, to_standard_error = to_stderr);

    if print_colors
        SetConsoleColor (.None, to_standard_error = to_stderr);
}

LogMessage :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    msg := SPrint (fmt_str, ..args,, Temp);
    if msg.count == 0
        return;

    info : Log_Info;
    info.source_identifier = context.log_source_identifier;
    info.location     = location;
    info.common_flags = flags;
    info.user_flags   = user_flags;
    info.section      = context.log_section;

    context.logger (msg, context.logger_data, info);
}

LogWarning :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogMessage (fmt_str, ..args, location, flags | .WARNING, user_flags);
}

LogError :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogMessage (fmt_str, ..args, location, flags | .ERROR, user_flags);
}

LogContentMessage :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogMessage (fmt_str, ..args, location, flags | .CONTENT, user_flags);
}

LogContentWarning :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogContentMessage (fmt_str, ..args, location, flags | .WARNING, user_flags);
}

LogContentError :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogContentMessage (fmt_str, ..args, location, flags | .ERROR, user_flags);
}
