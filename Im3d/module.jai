#scope_module

Linalg :: #import "Linalg";

Vec2 :: Linalg.Vec2f;
Vec3 :: Linalg.Vec3f;
Vec4 :: Linalg.Vec4f;
Mat3 :: Linalg.Mat3f;
Mat4 :: Linalg.Mat4f;

#scope_export

#if OS == .WINDOWS
    #load "windows.jai";
else #if OS == .LINUX
    #load "linux.jai";
else
    #assert false "Unsupported OS";

// Add text. See TextFlags_ enum for _textFlags. _size is a hint to the application-side text rendering.
Text :: (_position: Vec3, _textFlags: U32, _text: *u8, __args: ..Any)
{
    Text (*_position, _textFlags, _text, __args);
}

Text :: (_position: Vec3, _size: float, _color: Color, _textFlags: U32, _text: *u8, __args: ..Any)
{
    Text (*_position, _size, _color, _textFlags, _text, __args);
}

