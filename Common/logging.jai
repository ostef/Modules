SetContextLogger :: inline (data : *void, proc : Logger)
{
    context.logger_data = data;
    context.logger = proc;
}

ConsoleLogger :: struct
{
    report_filenames := true;
}

ConsoleLoggerProc :: (message : string, data : *void, info : Log_Info)
{
    if !message
        return;

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

    str := StringBuilderBuild (*builder, allocator = Temp);

    write_string (str, to_standard_error = (info.common_flags | .ERROR) != 0);
}

LogMessage :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0, section : *Log_Section = null)
{
    msg := FormatString (Temp, fmt_str, ..args);
    if msg.count == 0
        return;

    info : Log_Info;
    info.source_identifier = context.log_source_identifier;
    info.location     = location;
    info.common_flags = flags;
    info.user_flags   = user_flags;
    info.section      = section;

    context.logger (msg, context.logger_data, info);
}

LogMessage :: inline (section : *Log_Section, fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogMessage (fmt_str, ..args, location, flags, user_flags, section);
}

LogWarning :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0, section : *Log_Section = null)
{
    LogMessage (fmt_str, ..args, location, flags | .WARNING, user_flags, section);
}

LogWarning :: inline (section : *Log_Section, fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogMessage (fmt_str, ..args, location, flags | .WARNING, user_flags, section);
}

LogError :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0, section : *Log_Section = null)
{
    LogMessage (fmt_str, ..args, location, flags | .ERROR, user_flags, section);
}

LogError :: inline (section : *Log_Section, fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogMessage (fmt_str, ..args, location, flags | .ERROR, user_flags, section);
}

LogContentMessage :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0, section : *Log_Section = null)
{
    LogMessage (fmt_str, ..args, location, flags | .CONTENT, user_flags, section);
}

LogContentMessage :: inline (section : *Log_Section, fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogMessage (fmt_str, ..args, location, flags | .CONTENT, user_flags, section);
}

LogContentWarning :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0, section : *Log_Section = null)
{
    LogContentMessage (fmt_str, ..args, location, flags | .WARNING, user_flags, section);
}

LogContentWarning :: inline (section : *Log_Section, fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogContentMessage (fmt_str, ..args, location, flags | .WARNING, user_flags, section);
}

LogContentError :: inline (fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0, section : *Log_Section = null)
{
    LogContentMessage (fmt_str, ..args, location, flags | .ERROR, user_flags, section);
}

LogContentError :: inline (section : *Log_Section, fmt_str : string, args : ..Any, location := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0)
{
    LogContentMessage (fmt_str, ..args, location, flags | .ERROR, user_flags, section);
}
