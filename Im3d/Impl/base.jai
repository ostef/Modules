#import "Linalg";
Math :: #import "Math";
#import "SDL";

ImplData :: struct
{
    window : *SDL_Window;
    view_projection_matrix : Mat4f;
    projection_matrix : Mat4f;
    using renderer_data : RendererData;
}

GetData :: inline () -> *ImplData #must
{
    return cast (*ImplData) Im3d.GetAppData ().appData;
}

GetRendererData :: inline () -> *RendererData #must
{
    return *GetData ().renderer_data;
}

Init :: (window : *SDL_Window) -> bool
{
    data := Alloc (ImplData);
    data.window = window;
    Im3d.GetAppData ().appData = data;

    return InitRendererData ();
}

Terminate :: ()
{
    CleanupRendererData ();
    Free (Im3d.GetAppData ().appData);
    Im3d.GetAppData ().appData = null;
}

NewFrame :: (fov : float, mouse_pos : Vec2f, camera_transform : Mat4f, projection : Mat4f, delta_time : float, use_orthographic_projection := false)
{
    app := Im3d.GetAppData ();
    data := GetData ();
    view_matrix := inverse (camera_transform);
    data.view_projection_matrix = projection * view_matrix;

    app.deltaTime = delta_time;

    width, height : s32;
    SDL_GetWindowSize (data.window, *width, *height);
    app.viewportSize.x = xx width;
    app.viewportSize.y = xx height;

    app.viewOrigin = translation_vector (camera_transform);
    app.viewDirection = forward_vector (camera_transform);
    app.projOrtho = use_orthographic_projection;

    cursor_pos := Vec2f.{
        mouse_pos.x / app.viewportSize.x - 0.5,
        mouse_pos.y / app.viewportSize.y - 0.5
    } * 2;
    cursor_pos.y = -cursor_pos.y;

    if app.projOrtho
    {
        app.projScaleY = 2 / projection.r1c1;

        app.cursorRayOrigin.x = cursor_pos.x / projection.r0c0;
        app.cursorRayOrigin.y = cursor_pos.y / projection.r1c1;
        app.cursorRayOrigin.z = 0;
        app.cursorRayOrigin = transform_point (camera_transform, app.cursorRayOrigin);

        app.cursorRayDirection = app.viewDirection;
    }
    else
    {
        app.projScaleY = 2 * Math.tan ((fov * Math.PI / 180.0) * 0.5);

        app.cursorRayOrigin = app.viewOrigin;

        app.cursorRayDirection.x = cursor_pos.x / projection.r0c0;
        app.cursorRayDirection.y = cursor_pos.y / projection.r1c1;
        app.cursorRayDirection.z = 1;
        app.cursorRayDirection = transform_vector (camera_transform, normalized (app.cursorRayDirection));
    }

    Im3d.AppData.setCullFrustum (app, data.view_projection_matrix, true);
}

RenderTextDrawListsUsingImGui :: (text_draw_lists : *Im3d.TextDrawList, count : s64)
{
    ImGui :: #import "ImGui";

    impl_data := GetData ();

    ImGui.PushStyleColor (.WindowBg, 0);
    defer ImGui.PopStyleColor ();

    ImGui.SetNextWindowPos (ImGui.GetMainViewport ().Pos);
    ImGui.SetNextWindowSize (ImGui.GetMainViewport ().Size);
    ImGui.SetNextWindowViewport (ImGui.GetMainViewport ().ID_);
    ImGui.Begin ("Im3d Text Window", null,
        .NoTitleBar
        | .NoResize
        | .NoScrollbar
        | .NoInputs
        | .NoSavedSettings
        | .NoFocusOnAppearing
        | .NoBringToFrontOnFocus
    );
    defer ImGui.End ();

    im_draw_list := ImGui.GetWindowDrawList ();
    view_proj := impl_data.view_projection_matrix;
    for i : 0..count - 1
    {
        text_draw_list := text_draw_lists[i];
        if text_draw_list.textDataCount == 0
            continue;

        for j : 0..text_draw_list.textDataCount - 1
        {
            text_data := text_draw_list.textData[j];

            // Project world space to screen space
            clip := view_proj * Vec4f.{text_data.positionSize.x, text_data.positionSize.y, text_data.positionSize.z, 1};
            screen := Vec2f.{clip.x / clip.w, clip.y / clip.w};

            // Cull text which falls offscreen. Note that this doesn't take into account text size but works well enough in practice.
            if clip.w < 0 //|| screen.x >= 1 || screen.y >= 1
                continue;

            // Transform screen coordinates to ImGuiWindow coordinates
            screen = screen * 0.5 + Vec2f.{0.5, 0.5};
            screen.y = 1.0 - screen.y;
            screen = ImGui.GetWindowPos () + scale (screen, ImGui.GetWindowSize ());

            text := text_draw_list.textBuffer + text_data.textBufferOffset;

            ImGui.SetWindowFontScale (text_data.positionSize.w);
            text_size := ImGui.CalcTextSize (text, text + text_data.textLength);
            ImGui.SetWindowFontScale (1);

            // Set pixel offset based on text flags
            text_offset := Vec2f.{-text_size.x * 0.5, -text_size.y * 0.5};
            flags := cast (Im3d.TextFlags) text_data.flags;
            if (flags & .AlignLeft) != 0
                text_offset.x -= text_size.x;
            if (flags & .AlignRight) != 0
                text_offset.x = 0;
            if (flags & .AlignTop) != 0
                text_offset.y -= text_size.y;
            if (flags & .AlignBottom) != 0
                text_offset.y = 0;

            screen += text_offset;
            im_draw_list.AddText (
                im_draw_list,
                null,
                text_data.positionSize.w * ImGui.GetFontSize (),
                screen,
                text_data.color.v,
                MakeString (text_data.textLength, text)
            );
        }
    }
}
