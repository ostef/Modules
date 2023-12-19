#scope_file

#import "Common";
Basic :: #import "Basic";

#scope_export

Lexer :: struct
{
    name : string;

    #place name;
    filename : string;

    text : string;
    byte_index : s64;
    column := 1;
    line := 1;

    has_errors : bool;
}

LexerIsAtEnd :: inline (using lexer : Lexer) -> bool #must
{
    return byte_index >= text.count;
}

LexerAdvance :: (using lexer : *Lexer, count := 1) -> int
{
    i := 0;
    while !LexerIsAtEnd (lexer) && i < count
    {
        if text[byte_index] == #char "\n"
        {
            column = 0;
            line += 1;
        }

        byte_index += 1;
        column += 1;
        i += 1;
    }

    return i;
}

LexerRemainingBytes :: inline (using lexer : Lexer) -> int #must
{
    return Max (text.count - byte_index, 0);
}

LexerEqualsString :: inline (using lexer : Lexer, str : string) -> bool #must
{
    if LexerRemainingBytes (lexer) < str.count
        return false;

    remaining_str : string = ---;
    remaining_str.data = text.data + byte_index;
    remaining_str.count = str.count;

    return remaining_str == str;
}

LexerMatchString :: inline (using lexer : *Lexer, str : string) -> bool #must
{
    if LexerEqualsString (lexer, str)
    {
        LexerAdvance (lexer, str.count);
        return true;
    }

    return false;
}

LexerEqualsAlphaNumeric :: inline (using lexer : Lexer, str : string) -> bool #must
{
    if !LexerEqualsString (lexer, str)
        return false;

    return LexerRemainingBytes (lexer) == str.count || !Basic.is_alnum (text[byte_index + str.count]);
}

LexerMatchAlphaNumeric :: inline (using lexer : *Lexer, str : string) -> bool #must
{
    if LexerEqualsAlphaNumeric (lexer, str)
    {
        LexerAdvance (lexer, str.count);
        return true;
    }

    return false;
}

LexerSkipWhitespacesAndComments :: inline (using lexer : *Lexer)
{
    while !LexerIsAtEnd (lexer)
    {
        if Basic.is_space (text[byte_index])
        {
            LexerAdvance (lexer);
        }
        else if LexerMatchString (lexer, "//")
        {
            while !LexerIsAtEnd (lexer) && text[byte_index] != #char "\n" && text[byte_index] != #char "\r"
                LexerAdvance (lexer);
        }
        else if LexerEqualsString (lexer, "/*")
        {
            LexerAdvance (lexer, 2);

            level := 1;
            while !LexerIsAtEnd (lexer) && level > 0
            {
                if LexerMatchString (lexer, "/*")
                    level += 1;
                else if LexerMatchString (lexer, "*/")
                    level -= 1;
                else
                    LexerAdvance (lexer);
            }

            // if level != 0
            //     syntax_error (tok, "unclosed comment");
        }
        else
            break;
    }
}

LexerScanQuotedString :: (using lexer : *Lexer, allowed_quotes := "\"", allocator := context.allocator) -> string, bool
{
    if LexerIsAtEnd (lexer)
        return "", false;

    quote : u8;
    for i : 0..allowed_quotes.count - 1
    {
        if text[byte_index] == allowed_quotes[i]
        {
            quote = allowed_quotes[i];
            break;
        }
    }

    if !quote
        return "", false;

    LexerAdvance (lexer);

    builder : StringBuilder;
    builder.allocator = Temp;

    while !LexerIsAtEnd (lexer) && text[byte_index] != quote
    {
        if text[byte_index] == #char "\\"
        {
            LexerAdvance (lexer);

            if LexerIsAtEnd (lexer)
                break;

            if text[byte_index] == quote
            {
                StringBuilderAppendByte (*builder, quote);
            }
            else if text[byte_index] ==
            {
            case #char "n";  StringBuilderAppendByte (*builder, #char "\n");
            case #char "\\"; StringBuilderAppendByte (*builder, #char "\\");
            case #char "r";  StringBuilderAppendByte (*builder, #char "\r");
            case #char "t";  StringBuilderAppendByte (*builder, #char "\t");
            }

            LexerAdvance (lexer);
        }
        else
        {
            StringBuilderAppendByte (*builder, text[byte_index]);
            LexerAdvance (lexer);
        }
    }

    if LexerIsAtEnd (lexer)
        return "", false;

    LexerAdvance (lexer);

    return StringBuilderBuild (*builder, allocator = allocator), true;
}

SyntaxError :: (using lexer : *Lexer, fmt_str : string, args : ..Any)
{
    has_errors = true;
    msg := FormatString (Temp, fmt_str, ..args);
    LogError ("%:%:%, syntax error: %", name, line, column, msg);
}
