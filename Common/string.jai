Utf8String :: struct
{
    count : s64;
    data : *u8;

    #place count;
    as_string : string;
}

MakeUtf8String :: inline (str : string) -> Utf8String #must
{
    return .{as_string=str};
}

MakeUtf8String :: inline (count : s64, data : *u8) -> Utf8String #must
#deprecated "Use a struct literal directly"
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
#deprecated "Use a struct literal directly"
{
    str : string = ---;
    str.count = count;
    str.data = data;

    return str;
}

MakeString :: inline (cstr : *u8) -> string #must
{
    return .{StringLength (cstr), cstr};
}

StringFromArray :: inline (arr : []u8) -> string #must
#deprecated "Use a cast"
{
    return MakeString (arr.count, arr.data);
}

StringToArray :: inline (str : string) -> []u8 #must
#deprecated "Use a cast"
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
    n := Min (a.count, b.count);
    for i : 0..n - 1
    {
        cmp := cast (int) a[i] - cast (int) b[i];
        if cmp != 0
            return cmp;
    }

    if a.count < b.count
        return -cast (int) b[a.count];
    else if a.count > b.count
        return cast (int) a[b.count];
    else
        return 0;
}

StringClone :: inline (str : string) -> string #must
{
    data := cast (*u8) Alloc (str.count);
    memcpy (data, str.data, str.count);

    return .{str.count, data};
}

CStringClone :: StringCloneToCString;
StringCloneToCString :: inline (str : string) -> *u8 #must
{
    data := cast (*u8) Alloc (str.count + 1);
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

StringFindFirst :: inline (str : string, to_find : string) -> s64 #must
#no_abc
{
    for i : 0..str.count - 1
    {
        for j : 0..to_find.count - 1
        {
            if str[i] == to_find[j]
                return i;
        }
    }

    return -1;
}

StringFindLast :: inline (str : string, to_find : string) -> s64 #must
#no_abc
{
    for < i : str.count - 1..0
    {
        for j : 0..to_find.count - 1
        {
            if str[i] == to_find[j]
                return i;
        }
    }

    return -1;
}

StringAdvance :: inline (str : *string, count : int)
{
    if count > str.count
        count = str.count;

    str.data += count;
    str.count -= count;
}

StringAdvance :: inline (str : string, count : int) -> string #must
{
    result := str;
    StringAdvance (*result, count);

    return result;
}

StringJoin :: (args : ..string) -> string #must
#no_abc
{
    total_size := 0;
    for args
        total_size += it.count;

    if total_size == 0
        return "";

    data := cast (*u8) Alloc (total_size);

    i := 0;
    for args
    {
        memcpy (data + i, it.data, it.count);
        i += it.count;
    }

    return .{total_size, data};
}

StringJoin :: (allocator : Allocator, args : ..string) -> string #must
#deprecated "Use a context argument instead: StringJoin (\"Hello\", \"Sailor\",, allocator)"
{
    return StringJoin (..args,, allocator);
}
