#module_parameters () (Enable_Asserts := true);

Formatter :: Basic.Formatter;
FormatInt :: Basic.FormatInt;
FormatFloat :: Basic.FormatFloat;
FormatStruct :: Basic.FormatStruct;
FormatArray :: Basic.FormatArray;

FormatString :: (format_string : string, args : ..Any) -> string #must
{
    builder : StringBuilder;
    builder.allocator = context.allocator;
    StringBuilderAppend (*builder, format_string, ..args);

    return StringBuilderBuild (*builder);
}
@PrintLike

FormatString :: (allocator : Allocator, format_string : string, args : ..Any) -> string #must
{
    builder : StringBuilder;
    builder.allocator = allocator;
    StringBuilderAppend (*builder, format_string, ..args);

    return StringBuilderBuild (*builder, allocator = allocator);
}
@PrintLike

FormatToCString :: (format_string : string, args : ..Any) -> *u8 #must
{
    builder : StringBuilder;
    builder.allocator = context.allocator;
    StringBuilderAppend (*builder, format_string, ..args);

    return StringBuilderBuildCstr (*builder);
}
@PrintLike

FormatToCString :: (allocator : Allocator, format_string : string, args : ..Any) -> *u8 #must
{
    builder : StringBuilder;
    builder.allocator = allocator;
    StringBuilderAppend (*builder, format_string, ..args);

    return StringBuilderBuildCstr (*builder, allocator = allocator);
}
@PrintLike

Print :: Basic.print;

Println :: inline (format_string : string, args : ..Any, to_standard_error := false) -> s64
{
    return Print (format_string, ..args, to_standard_error = to_standard_error)
        + Print ("\n", to_standard_error = to_standard_error);
}
@PrintLike

#load "memory.jai";
#load "array.jai";
#load "string.jai";
#load "string_builder.jai";
#load "logging.jai";

#if Basic.MEMORY_DEBUGGER
{
    Common_Allocation_Leaves :: Basic.Procedure_To_Elide.[
        .{"AllocNonNull", "Common"},
        .{"Alloc", "Common"},
        .{"AllocArray", "Common"},
        .{"Realloc", "Common"},
        .{"StringClone", "Common"},
        .{"StringCloneToCString", "Common"},
        .{"StringJoin", "Common"},
        .{"FormatString", "Common"},
        .{"FormatToCString", "Common"},
        .{"ArrayReserve", "Common"},
        .{"HashMapInit", "Hash_Map"},
        .{"HashMapGrow", "Hash_Map"},
    ];
}

Assert :: (assertion : bool, format_string := "", args : ..Any, location := #caller_location) #expand
{
    #if Enable_Asserts
    {
        if !assertion && Basic.assert_helper (format_string, ..args, location)
            debug_break ();
    }
}
@PrintLike

#add_context panicking := false;

Panic :: (format_string := "", args : ..Any, location := #caller_location) #expand
{
    context.panicking = true;
    defer context.panicking = false;

    Assert (false, format_string, ..args, location = location);
}
@PrintLike

Initialize :: inline (item : *$T)
{
    initializer :: initializer_of (T);
    #if initializer
        initializer (item);
    else
        memset (item, 0, size_of (T));
}

Initialize :: inline (item : *$T, count : s64)
{
    initializer :: initializer_of (T);
    #if initializer
    {
        for i : 0..count - 1
            initializer (item + i);
    }
    else
    {
        memset (item, 0, size_of (T) * count);
    }
}

OffsetOf :: ($T : Type, $member : string) -> s64 #must #expand
{
    dummy := cast (*T) null;

    #insert #run FormatString ("return cast (s64) *dummy.%;", member);
}

DefaultValue :: ($T : Type) -> T #expand
{
    val : T;

    return val;
}

#scope_file

IsNumeric :: inline (type : Type) -> bool
{
    info := cast (*Type_Info) type;

    return info.type == .INTEGER || info.type == .FLOAT;
}

#scope_export

Min :: (a : $T, b : T) -> T #must #expand
#modify { return IsNumeric (T); }
{
    return ifx a < b then a else b;
}

Max :: (a : $T, b : T) -> T #must #expand
#modify { return IsNumeric (T); }
{
    return ifx a > b then a else b;
}

MinMax :: (a : $T, b : T) -> min : T, max : T #must #expand
#modify { return IsNumeric (T); }
{
    if a < b
        return a, b;
    else
        return b, a;
}

Clamp :: (x : $T, min : T, max : T) -> T #must #expand
#modify { return IsNumeric (T); }
{
    return Min (Max (x, min), max);
}

Saturate :: (x : $T) -> T #must #expand
#modify { return IsNumeric (T); }
{
    return Clamp (x, 0, 1);
}

Abs :: (x : $T) -> T #must #expand
#modify { return IsNumeric (T); }
{
    return ifx x < 0 then -x else x;
}

Sign :: (x : $T) -> T #must #expand
#modify { return IsNumeric (T); }
{
    return cast (T) ifx x < 0 then -1 else ifx x > 0 then 1 else 0;
}

Lerp :: (a : float, b : float, t : float) -> float #must #expand
{
    return a * (1 - t) + b * t;
}

InverseLerp :: (a : float, b : float, t : float) -> float #must #expand
{
    return (t - a) / (b - a);
}

Round :: (value : float) -> float #must #expand
{
    return cast (float) (cast (int) (value + Sign (value) * 0.5));
}

SnapDown :: (value : float, grid_size : float) -> float #must #expand
{
    Math :: #import "Math";

    return Math.floor (value / grid_size) * grid_size;
}

Snap :: (value : float, grid_size : float) -> float #must #expand
{
    Math :: #import "Math";

    return Math.round (value / grid_size) * grid_size;
}

SnapUp :: (value : float, grid_size : float) -> float #must #expand
{
    Math :: #import "Math";

    return Math.ceil (value / grid_size) * grid_size;
}
