StringBuilder :: Basic.String_Builder;

StringBuilderFree :: inline (builder : *StringBuilder)
{
    Basic.reset (builder);
}

StringBuilderLength :: inline (builder : *StringBuilder) -> s64 #must
{
    return Basic.builder_string_length (builder);
}

StringBuilderBuild :: inline (builder : *StringBuilder, allocator := context.allocator, reset_builder := true) -> string #must
{
    return Basic.builder_to_string (builder, allocator = allocator, do_reset = reset_builder);
}

StringBuilderBuildCstr :: (builder : *StringBuilder, allocator := context.allocator, reset_builder := true) -> *u8 #must
{
    if !builder.initialized
        Basic.init_string_builder (builder);

    count := StringBuilderLength (builder);
    result := Alloc (u8, count + 1, allocator);
    data := result;

    buffer := Basic.get_base_buffer (builder);
    while buffer
    {
        memcpy (data, Basic.get_buffer_data (buffer), buffer.count);
        data += buffer.count;

        next := buffer.next;

        if reset_builder && buffer != Basic.get_base_buffer (builder)
            Free (buffer, builder.allocator);

        buffer = next;
    }

    data.* = 0;

    return result;
}

StringBuilderWrite :: inline (builder : *StringBuilder, do_reset := true, to_standard_error := false) -> s64
{
    return Basic.write_builder (builder, do_reset, to_standard_error);
}

StringBuilderAppend :: inline (builder : *StringBuilder, format_string : string, args : ..Any) -> s64
{
    start_length := StringBuilderLength (builder);

    Basic.print_to_builder (builder, format_string, ..args);

    return StringBuilderLength (builder) - start_length;
}
@PrintLike

StringBuilderAppendLine :: inline (builder : *StringBuilder, format_string : string, args : ..Any) -> s64
{
    return StringBuilderAppend (builder, format_string, ..args) + StringBuilderAppendByte (builder, #char "\n");
}
@PrintLike

StringBuilderAppendString :: inline (builder : *StringBuilder, str : string) -> s64
{
    Basic.append (builder, str);

    return str.count;
}

StringBuilderAppendStringLiteral :: inline (builder : *StringBuilder, str : string, quotes := "\"") -> s64
{
    count := 0;

    count += StringBuilderAppend (builder, quotes);

    for i : 0..str.count - 1
    #no_abc
    {
        if str[i] ==
        {
        case #char "\\"; count += StringBuilderAppendString (builder, "\\\\");
        case #char "\t"; count += StringBuilderAppendString (builder, "\\t");
        case #char "\r"; count += StringBuilderAppendString (builder, "\\r");
        case #char "\n"; count += StringBuilderAppendString (builder, "\\n");
        case;            count += StringBuilderAppendByte (builder, str[i]);
        }
    }

    count += StringBuilderAppend (builder, quotes);

    return count;
}

StringBuilderAppendByte :: inline (builder : *StringBuilder, byte : u8) -> s64
{
    Basic.append (builder, byte);

    return 1;
}

StringBuilderAppendBuilder :: (builder : *StringBuilder, other : *StringBuilder) -> s64
{
    count : s64;
    buffer := Basic.get_base_buffer (other);
    while buffer
    {
        str := MakeString (buffer.count, Basic.get_buffer_data (buffer));
        count += StringBuilderAppendString (builder, str);

        buffer = buffer.next;
    }

    return count;
}
