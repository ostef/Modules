#module_parameters () (Enable_Asserts := true);

Formatter :: Basic.Formatter;
FormatInt :: Basic.FormatInt;
FormatFloat :: Basic.FormatFloat;
FormatStruct :: Basic.FormatStruct;
FormatArray :: Basic.FormatArray;

FormatIntHex :: inline (value : Any, digits := 16) -> FormatInt #must
{
    return .{value=value, base=16, minimum_digits=digits, padding=#char"0"};
}

FormatString :: (format_string : string, args : ..Any) -> string #must
#deprecated "The name of this function has been changed to SPrint"
{
    return SPrint (format_string, ..args);
}
@PrintLike

SPrint :: (format_string : string, args : ..Any) -> string #must
{
    builder : StringBuilder;
    builder.allocator = context.allocator;
    StringBuilderAppend (*builder, format_string, ..args);

    return StringBuilderBuild (*builder);
}
@PrintLike

FormatString :: (allocator : Allocator, format_string : string, args : ..Any) -> string #must
#deprecated "Use a context argument instead: FormatString (\"...\", ... ,, allocator)"
{
    builder : StringBuilder;
    builder.allocator = allocator;
    StringBuilderAppend (*builder, format_string, ..args);

    return StringBuilderBuild (*builder,, allocator);
}
@PrintLike

FormatToCString :: (format_string : string, args : ..Any) -> *u8 #must
#deprecated "The name of this function has been changed to CSPrint"
{
    return CSprint (format_string, ..args);
}
@PrintLike

CSPrint :: (format_string : string, args : ..Any) -> *u8 #must
{
    builder : StringBuilder;
    builder.allocator = context.allocator;
    StringBuilderAppend (*builder, format_string, ..args);

    return StringBuilderBuildCstr (*builder);
}
@PrintLike

FormatToCString :: (allocator : Allocator, format_string : string, args : ..Any) -> *u8 #must
#deprecated "Use a context argument instead: FormatToCString (\"...\", ... ,, allocator)"
{
    builder : StringBuilder;
    builder.allocator = allocator;
    StringBuilderAppend (*builder, format_string, ..args);

    return StringBuilderBuildCstr (*builder,, allocator);
}
@PrintLike

Print :: Basic.print;

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

OffsetOf :: inline ($T : Type, $member : string) -> s64 #must #no_context
{
    dummy := cast (*T) null;

    #insert #run SPrint ("// OffsetOf %.%\nreturn cast (s64) *dummy.%;", T, member, member);
}

DefaultValue :: inline ($T : Type) -> T #must #no_context
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

Min :: inline (a : $T, b : T) -> T #must #no_context
#modify { return IsNumeric (T); }
{
    return ifx a < b then a else b;
}

Max :: inline (a : $T, b : T) -> T #must #no_context
#modify { return IsNumeric (T); }
{
    return ifx a > b then a else b;
}

MinMax :: inline (a : $T, b : T) -> min : T, max : T #must #no_context
#modify { return IsNumeric (T); }
{
    if a < b
        return a, b;
    else
        return b, a;
}

Clamp :: inline (x : $T, min : T, max : T) -> T #must #no_context
#modify { return IsNumeric (T); }
{
    return Min (Max (x, min), max);
}

Saturate :: inline (x : $T) -> T #must #no_context
#modify { return IsNumeric (T); }
{
    return Clamp (x, 0, 1);
}

Abs :: inline (x : $T) -> T #must #no_context
#modify { return IsNumeric (T); }
{
    return ifx x < 0 then -x else x;
}

Sign :: inline (x : $T) -> T #must #no_context
#modify { return IsNumeric (T); }
{
    return cast (T) ifx x < 0 then -1 else ifx x > 0 then 1 else 0;
}

Lerp :: inline (a : float, b : float, t : float) -> float #must #no_context
{
    return a * (1 - t) + b * t;
}

InverseLerp :: inline (a : float, b : float, t : float) -> float #must #no_context
{
    return (t - a) / (b - a);
}

Round :: inline (value : float) -> float #must #no_context
{
    return cast (float) (cast (int) (value + Sign (value) * 0.5));
}

SnapDown :: inline (value : float, grid_size : float) -> float #must #no_context
{
    Math :: #import "Math";

    return Math.floor (value / grid_size) * grid_size;
}

Snap :: inline (value : float, grid_size : float) -> float #must #no_context
{
    Math :: #import "Math";

    return Math.round (value / grid_size) * grid_size;
}

SnapUp :: inline (value : float, grid_size : float) -> float #must #no_context
{
    Math :: #import "Math";

    return Math.ceil (value / grid_size) * grid_size;
}

Swap :: inline (a : *$T, b : *T) #no_context
{
    tmp := a.*;
    a.* = b.*;
    b.* = tmp;
}
