#import "Common";
#import "GL";
#import "GL_Utils";
Im3d :: #import "Im3d";

#load "../base.jai";
#load "shaders.jai";

RendererData :: struct
{
    ShaderData :: struct
    {
        handle : GLuint;
        viewport_uniform_loc : GLint;
        view_projection_uniform_loc : GLint;
    }

    points_shader : ShaderData;
    lines_shader : ShaderData;
    triangles_shader : ShaderData;
    vbo, vao : GLuint;
}

InitRendererData :: () -> bool
{
    data := GetRendererData ();

    state := GetTemporaryStorageState ();
    defer SetTemporaryStorageState (state);

    data.points_shader.handle = CreateShaderProgram (
        StringJoin (Points_Header, Vertex_Shader),
        StringJoin (Points_Header, Fragment_Shader)
    );

    if !data.points_shader.handle
    {
        LogError ("Could not create points shader program");
        return false;
    }

    data.points_shader.viewport_uniform_loc = glGetUniformLocation (data.points_shader.handle, "u_Viewport");
    data.points_shader.view_projection_uniform_loc = glGetUniformLocation (data.points_shader.handle, "u_View_Projection_Matrix");

    data.lines_shader.handle = CreateShaderProgram (
        StringJoin (Lines_Header, Vertex_Shader),
        StringJoin (Lines_Header, Fragment_Shader),
        StringJoin (Lines_Header, Geometry_Shader)
    );

    if !data.points_shader.handle
    {
        LogError ("Could not create lines shader program");
        return false;
    }

    data.lines_shader.viewport_uniform_loc = glGetUniformLocation (data.lines_shader.handle, "u_Viewport");
    data.lines_shader.view_projection_uniform_loc = glGetUniformLocation (data.lines_shader.handle, "u_View_Projection_Matrix");

    data.triangles_shader.handle = CreateShaderProgram (
        StringJoin (Triangles_Header, Vertex_Shader),
        StringJoin (Triangles_Header, Fragment_Shader),
    );

    if !data.triangles_shader.handle
    {
        LogError ("Could not create triangles shader program");
        return false;
    }

    data.triangles_shader.viewport_uniform_loc = glGetUniformLocation (data.triangles_shader.handle, "u_Viewport");
    data.triangles_shader.view_projection_uniform_loc = glGetUniformLocation (data.triangles_shader.handle, "u_View_Projection_Matrix");

    glGenVertexArrays (1, *data.vao);
    glBindVertexArray (data.vao);

    glGenBuffers (1, *data.vbo);
    glBindBuffer (GL_ARRAY_BUFFER, data.vbo);

    glEnableVertexAttribArray (0);
    glVertexAttribPointer (0, 4, GL_FLOAT, GL_FALSE, size_of (Im3d.VertexData), cast (*void) OffsetOf (Im3d.VertexData, "positionSize"));

    glEnableVertexAttribArray (1);
    glVertexAttribPointer (1, 4, GL_UNSIGNED_BYTE, GL_TRUE, size_of (Im3d.VertexData), cast (*void) OffsetOf (Im3d.VertexData, "color"));

    glBindBuffer (GL_ARRAY_BUFFER, 0);
    glBindVertexArray (0);

    return true;
}

CleanupRendererData :: ()
{
    data := GetRendererData ();
    glDeleteBuffers (1, *data.vbo);
    glDeleteVertexArrays (1, *data.vao);
    glDeleteProgram (data.points_shader.handle);
    glDeleteProgram (data.lines_shader.handle);
    glDeleteProgram (data.triangles_shader.handle);
}

RenderDrawLists :: (draw_lists : *Im3d.DrawList, count : s64)
{
    app_data := Im3d.GetAppData ();
    data := GetRendererData ();
    impl_data := GetData ();

    GL_POINT_SPRITE :: 0x8861;

    DisableBlock (GL_DEPTH_TEST);
    EnableBlock (GL_POINT_SPRITE);
    EnableBlock (GL_PROGRAM_POINT_SIZE);
    EnableBlock (GL_BLEND);
    glBlendEquation (GL_FUNC_ADD);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glBindVertexArray (data.vao);
    glBindBuffer (GL_ARRAY_BUFFER, data.vbo);

    for i : 0..count - 1
    {
        list := draw_lists[i];

        primitive : GLenum;
        shader : RendererData.ShaderData;
        if #complete list.primType ==
        {
        case .DrawPrimitive_Points;
            primitive = GL_POINTS;
            shader = data.points_shader;
            glDisable (GL_CULL_FACE);

        case .DrawPrimitive_Lines;
            primitive = GL_LINES;
            shader = data.lines_shader;
            glDisable (GL_CULL_FACE);

        case .DrawPrimitive_Triangles;
            primitive = GL_TRIANGLES;
            shader = data.triangles_shader;
            glEnable (GL_CULL_FACE);

        case .DrawPrimitive_Count;
            Panic ("Unreachable");
        }

        glBufferData (GL_ARRAY_BUFFER, list.vertexCount * size_of (Im3d.VertexData), list.vertexData, GL_DYNAMIC_DRAW);

        glUseProgram (shader.handle);
        glUniform2f (shader.viewport_uniform_loc, app_data.viewportSize.x, app_data.viewportSize.y);
        glUniformMatrix4fv (shader.view_projection_uniform_loc, 1, GL_TRUE, *impl_data.view_projection_matrix.r0c0);

        glDrawArrays (primitive, 0, xx list.vertexCount);
    }

    glBindVertexArray (0);
    glBindBuffer (GL_ARRAY_BUFFER, 0);
}
