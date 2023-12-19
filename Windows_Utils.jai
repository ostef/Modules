#scope_file

#import "Basic";
Win32 :: #import "Win32";

g_error_wide_buffer : [128]u16;
g_error_utf8_buffer : [512]u8;

#scope_export

GetLastErrorString :: inline () -> string #must
{
    return GetErrorString (Win32.GetLastError ());
}

// This function uses a static buffer, so calling it will modify the result  of the previous call
GetErrorString :: inline (error_code : u32) -> string #must
{
    wide_count := Win32.FormatMessageW (
        Win32.FORMAT_MESSAGE_FROM_SYSTEM | Win32.FORMAT_MESSAGE_IGNORE_INSERTS,
        null,
        error_code,
        Win32.MAKELANGID (Win32.LANG_NEUTRAL, Win32.SUBLANG_DEFAULT),
        g_error_wide_buffer.data,
        g_error_wide_buffer.count,
        null
    );

    utf8_count := Win32.WideCharToMultiByte (
        Win32.CP_UTF8,
        0,
        g_error_wide_buffer.data,
        cast (s32) wide_count,
        cast (*s8) g_error_utf8_buffer.data,
        g_error_utf8_buffer.count,
        null,
        null
    );

    result : string = ---;
    result.data  = g_error_utf8_buffer.data;
    result.count = utf8_count;

    return result;
}

// The result is null terminated even though a Jai string is returned
WideToUtf8 :: (data : *u16, allocator := context.allocator) -> string #must, success : bool
{
    result_length := Win32.WideCharToMultiByte (Win32.CP_UTF8, 0, data, -1, null, 0, null, null);
    if result_length <= 0
        return "", false;

    utf8_data := cast (*u8) alloc (result_length, allocator.data);

    written := Win32.WideCharToMultiByte (Win32.CP_UTF8, 0, data, -1, cast (*s8) utf8_data, result_length, null, null);
    if written > 0
    {
        str : string = ---;
        str.data  = utf8_data;
        str.count = written - 1;

        return str, true;
    }

    return "", false;
}

// The result is null terminated
Utf8ToWide :: (utf8_str : string, allocator := context.allocator) -> wide_str : *u16 #must, length : s32
{
    if !utf8_str
    {
        wide_str := cast (*u16) alloc (size_of (u16), allocator);
        wide_str[0] = 0;

        return wide_str, 0;
    }

    result_length := Win32.MultiByteToWideChar (Win32.CP_UTF8, 0, cast (*s8) utf8_str.data, cast (s32) utf8_str.count, null, 0);
    if result_length <= 0
        return null, 0;

    wide_str := cast (*u16) alloc ((result_length + 1) * size_of (u16), allocator);
    written := Win32.MultiByteToWideChar (Win32.CP_UTF8, 0, cast (*s8) utf8_str.data, cast (s32) utf8_str.count, wide_str, result_length);
    if written > 0
    {
        wide_str[written] = 0;

        return wide_str, written;
    }

    return null, 0;
}

