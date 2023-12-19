Utf8String :: struct
{
    count : s64;
    data : *u8;

    #place count;
    as_string : string;
}

MakeUtf8String :: inline (str : string) -> Utf8String #must
{
    return .{str.count, str.data};
}

MakeUtf8String :: inline (count : s64, data : *u8) -> Utf8String #must
{
    return .{count, data};
}

for_expansion :: (str : Utf8String, body : Code, flags : For_Flags) #expand
{
    Unicode :: #import "Unicode";

    `it_index := 0;
    byte_index := 0;
    while byte_index < str.count
    {
        `it, len := Unicode.character_utf8_to_utf32 (str.data + byte_index, str.count - byte_index);

        defer {
            it_index += 1;
            byte_index += len;
        }

        #insert body;
    }
}

MakeString :: inline (count : s64, data : *u8) -> string #must
{
    str : string = ---;
    str.count = count;
    str.data = data;

    return str;
}

MakeString :: inline (cstr : *u8) -> string #must
{
    return MakeString (StringLength (cstr), cstr);
}

StringFromArray :: inline (arr : []u8) -> string #must
{
    return MakeString (arr.count, arr.data);
}

StringToArray :: inline (str : string) -> []u8 #must
{
    return MakeArray (str.count, str.data);
}

StringLength :: inline (str : *u8) -> s64 #must
{
    i := 0;
    while str[i]
        i += 1;

    return i;
}

StringCompare :: inline (a : string, b : string) -> int #must
#no_abc
{
    if a.count < b.count
        return -cast (int) b[a.count - 1];

    if a.count > b.count
        return cast (int) a[b.count - 1];

    for i : 0..a.count - 1
    {
        cmp := cast (int) a[i] - cast (int) b[i];
        if cmp != 0
            return cmp;
    }

    return 0;
}

StringClone :: inline (str : string, allocator := context.allocator) -> string #must
{
    data := cast (*u8) Alloc (str.count, allocator);
    memcpy (data, str.data, str.count);

    return MakeString (str.count, data);
}

StringCloneToCString :: inline (str : string, allocator := context.allocator) -> *u8 #must
{
    data := cast (*u8) Alloc (str.count + 1, allocator);
    memcpy (data, str.data, str.count);
    data[str.count] = 0;

    return data;
}

StringStartsWith :: inline (str : string, with : string) -> bool #must
#no_abc
{
    if str.count < with.count
        return false;

    for i : 0..with.count - 1
    {
        if str[i] != with[i]
            return false;
    }

    return true;
}

StringEndsWith :: inline (str : string, with : string) -> bool #must
#no_abc
{
    if str.count < with.count
        return false;

    for i : 0..with.count - 1
    {
        if str[str.count - 1 - i] != with[with.count - 1 - i]
            return false;
    }

    return true;
}

StringFindFirst :: inline (str : string, needle : string) -> s64 #must
#no_abc
{
    for i : 0..str.count - 1
    {
        for j : 0..needle.count - 1
        {
            if str[i] == needle[j]
                return i;
        }
    }

    return -1;
}

StringFindLast :: inline (str : string, needle : string) -> s64 #must
#no_abc
{
    for < i : str.count - 1..0
    {
        for j : 0..needle.count - 1
        {
            if str[i] == needle[j]
                return i;
        }
    }

    return -1;
}

StringJoin :: (allocator : Allocator, args : ..string) -> string #must
#no_abc
{
    total_size := 0;
    for args
        total_size += it.count;

    if total_size == 0
        return "";

    data := cast (*u8) Alloc (total_size, allocator);

    i := 0;
    for args
    {
        memcpy (data + i, it.data, it.count);
        i += it.count;
    }

    return MakeString (total_size, data);
}

StringJoin :: inline (args : ..string) -> string #must
{
    return StringJoin (context.allocator, ..args);
}
