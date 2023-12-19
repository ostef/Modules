#scope_module

#import "Common";
Math :: #import "Math";
Linalg :: #import "Linalg";

FLOAT32_MIN :: Math.FLOAT32_MIN;
FLOAT32_MAX :: Math.FLOAT32_MAX;

size_t :: u64;

#scope_export

#if OS == .WINDOWS
{
    #load "windows.jai";

    user32 :: #system_library "User32";	// Needed unless ImGui is compiled with IMGUI_DISABLE_WIN32_DEFAULT_CLIPBOARD_FUNCS
}
else #if OS == .LINUX
{
    #load "linux.jai";
}
else
{
    #assert false "Unsupported OS";
}

ImVec2 :: Linalg.Vec2f;
ImVec4 :: Linalg.Vec4f;
ImColor:: Linalg.Vec4f;

ImVector :: struct (T : Type)
{
    Size     : s32;
    Capacity : s32;
    Data     : *T;

    Free :: inline (using vec : *ImVector)
    {
        MemFree (Data);
        Data = null;
        Size = 0;
        Capacity = 0;
    }

    Reserve :: inline (using vec : *ImVector, new_capacity : s32)
    {
        if new_capacity < Capacity
            return;

        new_data := MemAlloc (xx (new_capacity * size_of (T)));
        Assert (new_data != null);

        if Data
        {
            memcpy (new_data, Data, Size * size_of (T));
            MemFree (Data);
        }

        Data = new_data;
        Capacity = new_capacity;
    }

    Push :: inline (using vec : *ImVector, val : T)
    {
        if Size >= Capacity
            Reserve (vec, Capacity * 2 + 8);

        Data[Size] = val;
        Size += 1;
    }

    Pop :: inline (using vec : *ImVector)
    {
        Assert (Size > 0);

        Size -= 1;
    }
}

ImDrawCallback :: #type (parent_list : *ImDrawList, cmd : *ImDrawCmd) #c_call;
ImDrawCallback_ResetRenderState :: -1;
