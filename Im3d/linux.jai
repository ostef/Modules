//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



IM3D_MATRIX_ROW_MAJOR :: 1;

IM3D_VERSION :: "1.16";

IM3D_VERTEX_ALIGNMENT :: 4;

U32 :: u32;

Id :: U32;
Id_Invalid: Id : 0;

MulMatrix :: (_mat4: *Mat4) -> void #foreign im3d "_ZN4Im3d9MulMatrixERKNS_4Mat4E";
MulMatrix :: (_mat4: Mat4) #no_context {
    MulMatrix(*_mat4);
}
Translate :: (_x: float, _y: float, _z: float) -> void #foreign im3d "_ZN4Im3d9TranslateEfff";
Translate :: (_vec3: *Vec3) -> void #foreign im3d "_ZN4Im3d9TranslateERKNS_4Vec3E";
Translate :: (_vec3: Vec3) #no_context {
    Translate(*_vec3);
}
Rotate :: (_axis: *Vec3, _angle: float) -> void #foreign im3d "_ZN4Im3d6RotateERKNS_4Vec3Ef";
Rotate :: (_axis: Vec3, _angle: float) #no_context {
    Rotate(*_axis, _angle);
}
Rotate :: (_rotation: *Mat3) -> void #foreign im3d "_ZN4Im3d6RotateERKNS_4Mat3E";
Rotate :: (_rotation: Mat3) #no_context {
    Rotate(*_rotation);
}
Scale :: (_x: float, _y: float, _z: float) -> void #foreign im3d "_ZN4Im3d5ScaleEfff";

// High order shapes. Where _detail = -1, an automatic level of detail is chosen based on the distance to the view origin (as specified via the AppData struct).
DrawXyzAxes :: () -> void #foreign im3d "_ZN4Im3d11DrawXyzAxesEv";
DrawPoint :: (_position: *Vec3, _size: float, _color: Color) -> void #foreign im3d "_ZN4Im3d9DrawPointERKNS_4Vec3EfNS_5ColorE";
DrawPoint :: (_position: Vec3, _size: float, _color: Color) #no_context {
    DrawPoint(*_position, _size, _color);
}
DrawLine :: (_a: *Vec3, _b: *Vec3, _size: float, _color: Color) -> void #foreign im3d "_ZN4Im3d8DrawLineERKNS_4Vec3ES2_fNS_5ColorE";
DrawLine :: (_a: Vec3, _b: Vec3, _size: float, _color: Color) #no_context {
    DrawLine(*_a, *_b, _size, _color);
}
DrawQuad :: (_a: *Vec3, _b: *Vec3, _c: *Vec3, _d: *Vec3) -> void #foreign im3d "_ZN4Im3d8DrawQuadERKNS_4Vec3ES2_S2_S2_";
DrawQuad :: (_a: Vec3, _b: Vec3, _c: Vec3, _d: Vec3) #no_context {
    DrawQuad(*_a, *_b, *_c, *_d);
}
DrawQuad :: (_origin: *Vec3, _normal: *Vec3, _size: *Vec2) -> void #foreign im3d "_ZN4Im3d8DrawQuadERKNS_4Vec3ES2_RKNS_4Vec2E";
DrawQuad :: (_origin: Vec3, _normal: Vec3, _size: Vec2) #no_context {
    DrawQuad(*_origin, *_normal, *_size);
}
DrawQuadFilled :: (_a: *Vec3, _b: *Vec3, _c: *Vec3, _d: *Vec3) -> void #foreign im3d "_ZN4Im3d14DrawQuadFilledERKNS_4Vec3ES2_S2_S2_";
DrawQuadFilled :: (_a: Vec3, _b: Vec3, _c: Vec3, _d: Vec3) #no_context {
    DrawQuadFilled(*_a, *_b, *_c, *_d);
}
DrawQuadFilled :: (_origin: *Vec3, _normal: *Vec3, _size: *Vec2) -> void #foreign im3d "_ZN4Im3d14DrawQuadFilledERKNS_4Vec3ES2_RKNS_4Vec2E";
DrawQuadFilled :: (_origin: Vec3, _normal: Vec3, _size: Vec2) #no_context {
    DrawQuadFilled(*_origin, *_normal, *_size);
}
DrawCircle :: (_origin: *Vec3, _normal: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "_ZN4Im3d10DrawCircleERKNS_4Vec3ES2_fi";
DrawCircle :: (_origin: Vec3, _normal: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawCircle(*_origin, *_normal, _radius, _detail);
}
DrawCircleFilled :: (_origin: *Vec3, _normal: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "_ZN4Im3d16DrawCircleFilledERKNS_4Vec3ES2_fi";
DrawCircleFilled :: (_origin: Vec3, _normal: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawCircleFilled(*_origin, *_normal, _radius, _detail);
}
DrawSphere :: (_origin: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "_ZN4Im3d10DrawSphereERKNS_4Vec3Efi";
DrawSphere :: (_origin: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawSphere(*_origin, _radius, _detail);
}
DrawSphereFilled :: (_origin: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "_ZN4Im3d16DrawSphereFilledERKNS_4Vec3Efi";
DrawSphereFilled :: (_origin: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawSphereFilled(*_origin, _radius, _detail);
}
DrawAlignedBox :: (_min: *Vec3, _max: *Vec3) -> void #foreign im3d "_ZN4Im3d14DrawAlignedBoxERKNS_4Vec3ES2_";
DrawAlignedBox :: (_min: Vec3, _max: Vec3) #no_context {
    DrawAlignedBox(*_min, *_max);
}
DrawAlignedBoxFilled :: (_min: *Vec3, _max: *Vec3) -> void #foreign im3d "_ZN4Im3d20DrawAlignedBoxFilledERKNS_4Vec3ES2_";
DrawAlignedBoxFilled :: (_min: Vec3, _max: Vec3) #no_context {
    DrawAlignedBoxFilled(*_min, *_max);
}
DrawCylinder :: (_start: *Vec3, _end: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "_ZN4Im3d12DrawCylinderERKNS_4Vec3ES2_fi";
DrawCylinder :: (_start: Vec3, _end: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawCylinder(*_start, *_end, _radius, _detail);
}
DrawCapsule :: (_start: *Vec3, _end: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "_ZN4Im3d11DrawCapsuleERKNS_4Vec3ES2_fi";
DrawCapsule :: (_start: Vec3, _end: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawCapsule(*_start, *_end, _radius, _detail);
}
DrawPrism :: (_start: *Vec3, _end: *Vec3, _radius: float, _sides: s32) -> void #foreign im3d "_ZN4Im3d9DrawPrismERKNS_4Vec3ES2_fi";
DrawPrism :: (_start: Vec3, _end: Vec3, _radius: float, _sides: s32) #no_context {
    DrawPrism(*_start, *_end, _radius, _sides);
}
DrawArrow :: (_start: *Vec3, _end: *Vec3, _headLength: float = -1.0, _headThickness: float = -1.0) -> void #foreign im3d "_ZN4Im3d9DrawArrowERKNS_4Vec3ES2_ff";
DrawArrow :: (_start: Vec3, _end: Vec3, _headLength: float = -1.0, _headThickness: float = -1.0) #no_context {
    DrawArrow(*_start, *_end, _headLength, _headThickness);
}

// Add text. See TextFlags_ enum for _textFlags. _size is a hint to the application-side text rendering.
Text :: (_position: *Vec3, _textFlags: U32, _text: *u8, __args: ..Any) -> void #foreign im3d "_ZN4Im3d4TextERKNS_4Vec3EjPKcz";
Text :: (_position: *Vec3, _size: float, _color: Color, _textFlags: U32, _text: *u8, __args: ..Any) -> void #foreign im3d "_ZN4Im3d4TextERKNS_4Vec3EfNS_5ColorEjPKcz";

// IDs are used to uniquely identify gizmos and layers. Gizmo should have a unique ID during a frame.
// Note that ids are a hash of the whole ID stack, see PushId(), PopId().
MakeId :: (_str: *u8) -> Id #foreign im3d "_ZN4Im3d6MakeIdEPKc";
MakeId :: (_ptr: *void) -> Id #foreign im3d "_ZN4Im3d6MakeIdEPKv";
MakeId :: (_i: s32) -> Id #foreign im3d "_ZN4Im3d6MakeIdEi";

// Gizmo* overloads which take an ID directly. In some cases the app may want to call MakeId() separately, usually to change the gizmo appearance if hot/active.
GizmoTranslation :: (_id: Id, _translation_: *[3] float, _local := false) -> bool #foreign im3d "_ZN4Im3d16GizmoTranslationEjPfb";
GizmoRotation :: (_id: Id, _rotation_: *[9] float, _local := false) -> bool #foreign im3d "_ZN4Im3d13GizmoRotationEjPfb";
GizmoScale :: (_id: Id, _scale_: *[3] float) -> bool #foreign im3d "_ZN4Im3d10GizmoScaleEjPf";
Gizmo :: (_id: Id, _transform_: *[16] float) -> bool #foreign im3d "_ZN4Im3d5GizmoEjPf";
Gizmo :: (_id: Id, _translation_: *[3] float, _rotation_: *[9] float, _scale_: *[3] float) -> bool #foreign im3d "_ZN4Im3d5GizmoEjPfS0_S0_";

Color :: struct {
    v: U32; // rgba8 (MSB = r)

    Constructor :: (this: *Color, _rgba: *Vec4) -> void #cpp_method #foreign im3d "_ZN4Im3d5ColorC1ERKNS_4Vec4E";
    Constructor :: (this: *Color, _rgba: Vec4) #no_context {
        Constructor(this, *_rgba);
    }
    Constructor :: (this: *Color, _rgb: *Vec3, _alpha: float) -> void #cpp_method #foreign im3d "_ZN4Im3d5ColorC1ERKNS_4Vec3Ef";
    Constructor :: (this: *Color, _rgb: Vec3, _alpha: float) #no_context {
        Constructor(this, *_rgb, _alpha);
    }
    Constructor :: (this: *Color, _r: float, _g: float, _b: float, _a: float = 1.0) -> void #cpp_method #foreign im3d "_ZN4Im3d5ColorC1Effff";
}

Color_Black: Color : Color.{255};
Color_White: Color : Color.{4294967295};
Color_Gray: Color : Color.{2155905279};
Color_Red: Color : Color.{4278190335};
Color_Green: Color : Color.{16711935};
Color_Blue: Color : Color.{65535};
Color_Magenta: Color : Color.{4278255615};
Color_Yellow: Color : Color.{4294902015};
Color_Cyan: Color : Color.{16777215};

Color_Pink: Color : Color.{4290825215};
Color_Orange: Color : Color.{4289003775};
Color_Gold: Color : Color.{4292280575};
Color_Brown: Color : Color.{2336560127};
Color_Purple: Color : Color.{2147516671};
Color_Teal: Color : Color.{8421631};
Color_Navy: Color : Color.{33023};

VertexData :: struct {
    positionSize: Vec4; // xyz = position, w = size
    color:        Color; // rgba8 (MSB = r)
}

DrawPrimitiveType :: enum u32 {
    DrawPrimitive_Triangles :: 0;
    DrawPrimitive_Lines     :: 1;
    DrawPrimitive_Points    :: 2;

    DrawPrimitive_Count     :: 3;
}

DrawList :: struct {
    layerId:     Id;
    primType:    DrawPrimitiveType;
    vertexData:  *VertexData;
    vertexCount: U32;
}

DrawPrimitivesCallback :: #type (_drawList: *DrawList) -> void #c_call;

TextFlags :: enum u32 {
    AlignLeft   :: 1;
    AlignRight  :: 2;
    AlignTop    :: 8;
    AlignBottom :: 16;

    Default     :: 0;

    TextFlags_AlignLeft   :: AlignLeft;
    TextFlags_AlignRight  :: AlignRight;
    TextFlags_AlignTop    :: AlignTop;
    TextFlags_AlignBottom :: AlignBottom;

    TextFlags_Default     :: Default;
}

TextData :: struct {
    positionSize:     Vec4; // xyz = position, w = size
    color:            Color; // rgba8 (MSB = r)
    flags:            U32; // TextFlags
    textLength:       U32; // # chars in the text, excluding null terminator
    textBufferOffset: U32; // start of the text in the draw list's text buffer
}

TextDrawList :: struct {
    layerId:       Id;
    textData:      *TextData;
    textDataCount: U32;
    textBuffer:    *u8;
}

Key :: enum u32 {
    Mouse_Left              :: 0;
    L                       :: 1;
    R                       :: 2;
    S                       :: 3;
    T                       :: 4;

    Count                   :: 5;

    Action_Select           :: 0;
    Action_GizmoLocal       :: 1;
    Action_GizmoRotation    :: 2;
    Action_GizmoScale       :: 3;
    Action_GizmoTranslation :: 4;

    Action_Count            :: 5;

    Key_L     :: L;
    Key_R     :: R;
    Key_S     :: S;
    Key_T     :: T;

    Key_Count :: Count;
}

FrustumPlane :: enum u32 {
    Near   :: 0;
    Far    :: 1;
    Top    :: 2;
    Right  :: 3;
    Bottom :: 4;
    Left   :: 5;

    Count  :: 6;

    FrustumPlane_Near   :: Near;
    FrustumPlane_Far    :: Far;
    FrustumPlane_Top    :: Top;
    FrustumPlane_Right  :: Right;
    FrustumPlane_Bottom :: Bottom;
    FrustumPlane_Left   :: Left;

    FrustumPlane_Count  :: Count;
}

AppData :: struct {
    keyDown:             [5] bool; // Key states.
    cullFrustum:         [6] Vec4; // Frustum planes for culling (if culling enabled).
    cursorRayOrigin:     Vec3; // World space cursor ray origin.
    cursorRayDirection:  Vec3; // World space cursor ray direction.
    worldUp:             Vec3; // World space 'up' vector.
    viewOrigin:          Vec3; // World space render origin (camera position).
    viewDirection:       Vec3; // World space view direction.
    viewportSize:        Vec2; // Viewport size (pixels).
    projScaleY:          float = 1.0; // Scale factor used to convert from pixel size -> world scale; use tan(fov) for perspective projections, far plane height for ortho.
    projOrtho            := false; // If the projection matrix is orthographic.
    deltaTime:           float = 0.0; // Time since previous frame (seconds).
    snapTranslation:     float = 0.0; // Snap value for translation gizmos (world units). 0 = disabled.
    snapRotation:        float = 0.0; // Snap value for rotation gizmos (radians). 0 = disabled.
    snapScale:           float = 0.0; // Snap value for scale gizmos. 0 = disabled.
    flipGizmoWhenBehind  := true; // Flip gizmo axes when viewed from behind.
    appData:             *void = null; // App-specific data.

    drawCallback:        DrawPrimitivesCallback = null; // e.g. void Im3d_Draw(const DrawList& _drawList)

    // Extract cull frustum planes from the view-projection matrix.
    // Set _ndcZNegativeOneToOne = true if the proj matrix maps z from [-1,1] (OpenGL style).
    setCullFrustum :: (this: *AppData, _viewProj: *Mat4, _ndcZNegativeOneToOne: bool) -> void #cpp_method #foreign im3d "_ZN4Im3d7AppData14setCullFrustumERKNS_4Mat4Eb";
    setCullFrustum :: (this: *AppData, _viewProj: Mat4, _ndcZNegativeOneToOne: bool) #no_context {
        setCullFrustum(this, *_viewProj, _ndcZNegativeOneToOne);
    }
}

// Minimal vector.
Vector :: struct(T: Type) {
    data:     *T = null;
    size:     U32 = 0;
    capacity: U32 = 0;
}

PrimitiveMode :: enum u32 {
    None          :: 0;
    Points        :: 1;
    Lines         :: 2;
    LineStrip     :: 3;
    LineLoop      :: 4;
    Triangles     :: 5;
    TriangleStrip :: 6;

    PrimitiveMode_None          :: None;
    PrimitiveMode_Points        :: Points;
    PrimitiveMode_Lines         :: Lines;
    PrimitiveMode_LineStrip     :: LineStrip;
    PrimitiveMode_LineLoop      :: LineLoop;
    PrimitiveMode_Triangles     :: Triangles;
    PrimitiveMode_TriangleStrip :: TriangleStrip;
}

GizmoMode :: enum u32 {
    Translation :: 0;
    Rotation    :: 1;
    Scale       :: 2;

    GizmoMode_Translation :: Translation;
    GizmoMode_Rotation    :: Rotation;
    GizmoMode_Scale       :: Scale;
}

// Context stores all relevant state - main interface affects the context currently bound via SetCurrentContext().
Context :: struct {
    Constructor :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7ContextC1Ev";
    Destructor_Base :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7ContextD2Ev";
    Destructor :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7ContextD1Ev";

    begin :: (this: *Context, _mode: PrimitiveMode) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context5beginENS_13PrimitiveModeE";
    end :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context3endEv";

    vertex :: (this: *Context, _position: *Vec3, _size: float, _color: Color) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context6vertexERKNS_4Vec3EfNS_5ColorE";
    vertex :: (this: *Context, _position: Vec3, _size: float, _color: Color) #no_context {
        vertex(this, *_position, _size, _color);
    }

    text :: (this: *Context, _position: *Vec3, _size: float, _color: Color, _flags: TextFlags, _textStart: *u8, _textEnd: *u8) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context4textERKNS_4Vec3EfNS_5ColorENS_9TextFlagsEPKcS7_";
    text :: (this: *Context, _position: Vec3, _size: float, _color: Color, _flags: TextFlags, _textStart: *u8, _textEnd: *u8) #no_context {
        text(this, *_position, _size, _color, _flags, _textStart, _textEnd);
    }

    reset :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context5resetEv";
    merge :: (this: *Context, _src: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context5mergeERKS0_";
    merge :: (this: *Context, _src: Context) #no_context {
        merge(this, *_src);
    }
    endFrame :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context8endFrameEv";
    draw :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context4drawEv";

    setEnableSorting :: (this: *Context, _enable: bool) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context16setEnableSortingEb";

    pushEnableSorting :: (this: *Context, _enable: bool) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context17pushEnableSortingEb";
    popEnableSorting :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context16popEnableSortingEv";

    pushLayerId :: (this: *Context, _layer: Id) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context11pushLayerIdEj";
    popLayerId :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context10popLayerIdEv";

    // Low-level interface for internal and app-defined gizmos. May be subject to breaking changes.
    gizmoAxisTranslation_Behavior :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _snap: float, _worldHeight: float, _worldSize: float, _out_: *Vec3) -> bool #cpp_method #foreign im3d "_ZN4Im3d7Context29gizmoAxisTranslation_BehaviorEjRKNS_4Vec3ES3_fffPS1_";
    gizmoAxisTranslation_Behavior :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _snap: float, _worldHeight: float, _worldSize: float, _out_: *Vec3) -> bool #no_context {
        return gizmoAxisTranslation_Behavior(this, _id, *_origin, *_axis, _snap, _worldHeight, _worldSize, _out_);
    }
    gizmoAxisTranslation_Draw :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _worldHeight: float, _worldSize: float, _color: Color) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context25gizmoAxisTranslation_DrawEjRKNS_4Vec3ES3_ffNS_5ColorE";
    gizmoAxisTranslation_Draw :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _worldHeight: float, _worldSize: float, _color: Color) #no_context {
        gizmoAxisTranslation_Draw(this, _id, *_origin, *_axis, _worldHeight, _worldSize, _color);
    }

    gizmoPlaneTranslation_Behavior :: (this: *Context, _id: Id, _origin: *Vec3, _normal: *Vec3, _snap: float, _worldSize: float, _out_: *Vec3) -> bool #cpp_method #foreign im3d "_ZN4Im3d7Context30gizmoPlaneTranslation_BehaviorEjRKNS_4Vec3ES3_ffPS1_";
    gizmoPlaneTranslation_Behavior :: (this: *Context, _id: Id, _origin: Vec3, _normal: Vec3, _snap: float, _worldSize: float, _out_: *Vec3) -> bool #no_context {
        return gizmoPlaneTranslation_Behavior(this, _id, *_origin, *_normal, _snap, _worldSize, _out_);
    }
    gizmoPlaneTranslation_Draw :: (this: *Context, _id: Id, _origin: *Vec3, _normal: *Vec3, _worldSize: float, _color: Color) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context26gizmoPlaneTranslation_DrawEjRKNS_4Vec3ES3_fNS_5ColorE";
    gizmoPlaneTranslation_Draw :: (this: *Context, _id: Id, _origin: Vec3, _normal: Vec3, _worldSize: float, _color: Color) #no_context {
        gizmoPlaneTranslation_Draw(this, _id, *_origin, *_normal, _worldSize, _color);
    }

    gizmoAxislAngle_Behavior :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _snap: float, _worldRadius: float, _worldSize: float, _out_: *float) -> bool #cpp_method #foreign im3d "_ZN4Im3d7Context24gizmoAxislAngle_BehaviorEjRKNS_4Vec3ES3_fffPf";
    gizmoAxislAngle_Behavior :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _snap: float, _worldRadius: float, _worldSize: float, _out_: *float) -> bool #no_context {
        return gizmoAxislAngle_Behavior(this, _id, *_origin, *_axis, _snap, _worldRadius, _worldSize, _out_);
    }
    gizmoAxislAngle_Draw :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _worldRadius: float, _angle: float, _color: Color, _minAlpha: float) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context20gizmoAxislAngle_DrawEjRKNS_4Vec3ES3_ffNS_5ColorEf";
    gizmoAxislAngle_Draw :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _worldRadius: float, _angle: float, _color: Color, _minAlpha: float) #no_context {
        gizmoAxislAngle_Draw(this, _id, *_origin, *_axis, _worldRadius, _angle, _color, _minAlpha);
    }

    gizmoAxisScale_Behavior :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _snap: float, _worldHeight: float, _worldSize: float, _out_: *float) -> bool #cpp_method #foreign im3d "_ZN4Im3d7Context23gizmoAxisScale_BehaviorEjRKNS_4Vec3ES3_fffPf";
    gizmoAxisScale_Behavior :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _snap: float, _worldHeight: float, _worldSize: float, _out_: *float) -> bool #no_context {
        return gizmoAxisScale_Behavior(this, _id, *_origin, *_axis, _snap, _worldHeight, _worldSize, _out_);
    }
    gizmoAxisScale_Draw :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _worldHeight: float, _worldSize: float, _color: Color) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context19gizmoAxisScale_DrawEjRKNS_4Vec3ES3_ffNS_5ColorE";
    gizmoAxisScale_Draw :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _worldHeight: float, _worldSize: float, _color: Color) #no_context {
        gizmoAxisScale_Draw(this, _id, *_origin, *_axis, _worldHeight, _worldSize, _color);
    }

    // Convert pixels -> world space size based on distance between _position and view origin.
    pixelsToWorldSize :: (this: *Context, _position: *Vec3, _pixels: float) -> float #cpp_method #foreign im3d "_ZN4Im3d7Context17pixelsToWorldSizeERKNS_4Vec3Ef";
    pixelsToWorldSize :: (this: *Context, _position: Vec3, _pixels: float) -> float #no_context {
        return pixelsToWorldSize(this, *_position, _pixels);
    }

    // Convert world space size -> pixels based on distance between _position and view origin.
    worldSizeToPixels :: (this: *Context, _position: *Vec3, _pixels: float) -> float #cpp_method #foreign im3d "_ZN4Im3d7Context17worldSizeToPixelsERKNS_4Vec3Ef";
    worldSizeToPixels :: (this: *Context, _position: Vec3, _pixels: float) -> float #no_context {
        return worldSizeToPixels(this, *_position, _pixels);
    }

    // Blend between _min and _max based on distance betwen _position and view origin.
    estimateLevelOfDetail :: (this: *Context, _position: *Vec3, _worldSize: float, _min: s32 = 4, _max: s32 = 256) -> s32 #cpp_method #foreign im3d "_ZN4Im3d7Context21estimateLevelOfDetailERKNS_4Vec3Efii";
    estimateLevelOfDetail :: (this: *Context, _position: Vec3, _worldSize: float, _min: s32 = 4, _max: s32 = 256) -> s32 #no_context {
        return estimateLevelOfDetail(this, *_position, _worldSize, _min, _max);
    }

    // Make _id hot if _depth < m_hotDepth && _intersects.
    makeHot :: (this: *Context, _id: Id, _depth: float, _intersects: bool) -> bool #cpp_method #foreign im3d "_ZN4Im3d7Context7makeHotEjfb";

    // Make _id active.
    makeActive :: (this: *Context, _id: Id) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context10makeActiveEj";

    // Reset the acive/hot ids and the hot depth.
    resetId :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context7resetIdEv";

    // Visibiity tests for culling.
    isVisible :: (this: *Context, _vdata: *VertexData, _prim: DrawPrimitiveType) -> bool #cpp_method #foreign im3d "_ZN4Im3d7Context9isVisibleEPKNS_10VertexDataENS_17DrawPrimitiveTypeE";
    isVisible :: (this: *Context, _origin: *Vec3, _radius: float) -> bool #cpp_method #foreign im3d "_ZN4Im3d7Context9isVisibleERKNS_4Vec3Ef";
    isVisible :: (this: *Context, _origin: Vec3, _radius: float) -> bool #no_context {
        return isVisible(this, *_origin, _radius);
    }
    isVisible :: (this: *Context, _min: *Vec3, _max: *Vec3) -> bool #cpp_method #foreign im3d "_ZN4Im3d7Context9isVisibleERKNS_4Vec3ES3_";
    isVisible :: (this: *Context, _min: Vec3, _max: Vec3) -> bool #no_context {
        return isVisible(this, *_min, *_max);
    }

    gizmoLocal:         bool; // Global mode selection for gizmos.
    gizmoMode:          GizmoMode; //               "
    activeId:           Id; // Currently active gizmo. If set, this is the same as m_hotId.
    hotId:              Id; // ID of the current 'hot' gizmo (nearest intersecting gizmo along the cursor ray). NB this is the id of the *sub* gizmo, not the app-specified ID.
    hotDepth:           float; // Depth of the current hot gizmo along the cursor ray, for handling occlusion.
    appId:              Id; // Current ID *without* the hashing the ID stack (= _id arg to Gizmo* functions).
    appActiveId:        Id; // Copied from m_appId for the current active gizmo.
    appHotId:           Id; // Copied from m_appId for the current 'hot' gizmo.
    gizmoStateVec3:     Vec3; // Stored state for the active gizmo.
    gizmoStateMat3:     Mat3; //               "
    gizmoStateFloat:    float; //               "
    gizmoHeightPixels:  float; // Height/radius of gizmos.
    gizmoSizePixels:    float; // Thickness of gizmo lines.

    // Return the total number of primitives (sorted + unsorted) of the given _type in all layers.
    getPrimitiveCount :: (this: *Context, _type: DrawPrimitiveType) -> U32 #cpp_method #foreign im3d "_ZNK4Im3d7Context17getPrimitiveCountENS_17DrawPrimitiveTypeE";

    // Return the total number of text primitives in all layers.
    getTextCount :: (this: *Context) -> U32 #cpp_method #foreign im3d "_ZNK4Im3d7Context12getTextCountEv";

    // State stacks.
    colorStack:         Vector(Color);
    alphaStack:         Vector(float);
    sizeStack:          Vector(float);
    enableSortingStack: Vector(bool);
    matrixStack:        Vector(Mat4);
    idStack:            Vector(Id);
    layerIdStack:       Vector(Id);

    // Vertex data: one list per layer, per primitive type, *2 for sorted/unsorted.
    VertexList :: Vector(VertexData);
    vertexData:         [2] Vector(*VertexList); // Each layer is DrawPrimitive_Count consecutive lists.
    vertexDataIndex:    s32; // 0, or 1 if sorting enabled.
    layerIdMap:         Vector(Id); // Map Id -> vertex data index.
    layerIndex:         s32; // Index of the currently active layer in m_layerIdMap.
    drawLists:          Vector(DrawList); // All draw lists for the current frame, available after calling endFrame() before calling reset().
    sortCalled:         bool; // Avoid calling sort() during every call to draw().
    endFrameCalled:     bool; // For assert, if vertices are pushed after endFrame() was called.

    // Text data: one list per layer.
    TextList :: Vector(TextData);
    textData:           Vector(*TextList);
    textBuffer:         Vector(u8);
    textDrawLists:      Vector(TextDrawList);

    // Primitive state.
    primMode:           PrimitiveMode;
    primType:           DrawPrimitiveType;
    firstVertThisPrim:  U32; // Index of the first vertex pushed during this primitive.
    vertCountThisPrim:  U32; // # calls to vertex() since the last call to begin().
    minVertThisPrim:    Vec3;
    maxVertThisPrim:    Vec3;

    // App data.
    appData:            AppData;
    keyDownCurr:        [5] bool; // Key state captured during reset().
    keyDownPrev:        [5] bool; // Key state from previous frame.
    cullFrustum:        [6] Vec4; // Optimized frustum planes from m_appData.m_cullFrustum.
    cullFrustumCount:   s32; // # valid frustum planes in m_cullFrustum.

    // Sort primitive data.
    sort :: (this: *Context) -> void #cpp_method #foreign im3d "_ZN4Im3d7Context4sortEv";

    // Return -1 if _id not found.
    findLayerIndex :: (this: *Context, _id: Id) -> s32 #cpp_method #foreign im3d "_ZNK4Im3d7Context14findLayerIndexEj";

    // Access the current vertex/text data based on m_layerIndex.
    getCurrentVertexList :: (this: *Context) -> *VertexList #cpp_method #foreign im3d "_ZN4Im3d7Context20getCurrentVertexListEv";
    getCurrentTextList :: (this: *Context) -> *TextList #cpp_method #foreign im3d "_ZN4Im3d7Context18getCurrentTextListEv";
}

internal :: struct {
    g_CurrentContext: *Context;

    ScalarT :: struct {
        __empty_struct_padding: u8; // C++ makes empty structs have length 1
    }
    FloatT :: struct {
        #as using scalart: ScalarT;
    }
    IntT :: struct {
        #as using scalart: ScalarT;
    }
    CompositeT :: struct {
        __empty_struct_padding: u8; // C++ makes empty structs have length 1
    }
    VecT :: struct {
        #as using compositet: CompositeT;
    }
    MatT :: struct {
        #as using compositet: CompositeT;
    }

    TypeTraits :: struct(T: Type) {
        Type :: T;
        anon_enum_10 :: enum {
            kSize :: 0;
        }
    }
}

Transpose :: (_m: *Mat3) -> Mat3 #foreign im3d "_ZN4Im3d9TransposeERKNS_4Mat3E";
Transpose :: (_m: Mat3) -> Mat3 #no_context {
    return Transpose(*_m);
}
ToEulerXYZ :: (_m: *Mat3) -> Vec3 #foreign im3d "_ZN4Im3d10ToEulerXYZERKNS_4Mat3E";
ToEulerXYZ :: (_m: Mat3) -> Vec3 #no_context {
    return ToEulerXYZ(*_m);
}
FromEulerXYZ :: (_xyz: *Vec3) -> Mat3 #foreign im3d "_ZN4Im3d12FromEulerXYZERNS_4Vec3E";
Rotation :: (_axis: *Vec3, _rads: float) -> Mat3 #foreign im3d "_ZN4Im3d8RotationERKNS_4Vec3Ef";
Rotation :: (_axis: Vec3, _rads: float) -> Mat3 #no_context {
    return Rotation(*_axis, _rads);
}
Scale :: (_s: *Vec3) -> Mat3 #foreign im3d "_ZN4Im3d5ScaleERKNS_4Vec3E";
Scale :: (_s: Vec3) -> Mat3 #no_context {
    return Scale(*_s);
}

Inverse :: (_m: *Mat4) -> Mat4 #foreign im3d "_ZN4Im3d7InverseERKNS_4Mat4E";
Inverse :: (_m: Mat4) -> Mat4 #no_context {
    return Inverse(*_m);
}
Transpose :: (_m: *Mat4) -> Mat4 #foreign im3d "_ZN4Im3d9TransposeERKNS_4Mat4E";
Transpose :: (_m: Mat4) -> Mat4 #no_context {
    return Transpose(*_m);
}
Translation :: (_t: *Vec3) -> Mat4 #foreign im3d "_ZN4Im3d11TranslationERKNS_4Vec3E";
Translation :: (_t: Vec3) -> Mat4 #no_context {
    return Translation(*_t);
}
AlignZ :: (_axis: *Vec3, _up: *Vec3) -> Mat4 #foreign im3d "_ZN4Im3d6AlignZERKNS_4Vec3ES2_";
AlignZ :: (_axis: Vec3, _up: Vec3 = Vec3.{0.0, 1.0, 0.0}) -> Mat4 #no_context {
    return AlignZ(*_axis, *_up);
}
LookAt :: (_from: *Vec3, _to: *Vec3, _up: *Vec3) -> Mat4 #foreign im3d "_ZN4Im3d6LookAtERKNS_4Vec3ES2_S2_";
LookAt :: (_from: Vec3, _to: Vec3, _up: Vec3 = Vec3.{0.0, 1.0, 0.0}) -> Mat4 #no_context {
    return LookAt(*_from, *_to, *_up);
}

Line :: struct {
    origin:    Vec3;
    direction: Vec3; // unit length

    Constructor :: (this: *Line, _origin: *Vec3, _direction: *Vec3) -> void #cpp_method #foreign im3d "_ZN4Im3d4LineC1ERKNS_4Vec3ES3_";
    Constructor :: (this: *Line, _origin: Vec3, _direction: Vec3) #no_context {
        Constructor(this, *_origin, *_direction);
    }
}

Ray :: struct {
    origin:    Vec3;
    direction: Vec3; // unit length

    Constructor :: (this: *Ray, _origin: *Vec3, _direction: *Vec3) -> void #cpp_method #foreign im3d "_ZN4Im3d3RayC1ERKNS_4Vec3ES3_";
    Constructor :: (this: *Ray, _origin: Vec3, _direction: Vec3) #no_context {
        Constructor(this, *_origin, *_direction);
    }
}

LineSegment :: struct {
    start: Vec3;
    end:   Vec3;

    Constructor :: (this: *LineSegment, _start: *Vec3, _end: *Vec3) -> void #cpp_method #foreign im3d "_ZN4Im3d11LineSegmentC1ERKNS_4Vec3ES3_";
    Constructor :: (this: *LineSegment, _start: Vec3, _end: Vec3) #no_context {
        Constructor(this, *_start, *_end);
    }
}

Sphere :: struct {
    origin: Vec3;
    radius: float;

    Constructor :: (this: *Sphere, _origin: *Vec3, _radius: float) -> void #cpp_method #foreign im3d "_ZN4Im3d6SphereC1ERKNS_4Vec3Ef";
    Constructor :: (this: *Sphere, _origin: Vec3, _radius: float) #no_context {
        Constructor(this, *_origin, _radius);
    }
}

Plane :: struct {
    normal: Vec3;
    offset: float;

    Constructor :: (this: *Plane, _normal: *Vec3, _offset: float) -> void #cpp_method #foreign im3d "_ZN4Im3d5PlaneC1ERKNS_4Vec3Ef";
    Constructor :: (this: *Plane, _normal: Vec3, _offset: float) #no_context {
        Constructor(this, *_normal, _offset);
    }
    Constructor :: (this: *Plane, _normal: *Vec3, _origin: *Vec3) -> void #cpp_method #foreign im3d "_ZN4Im3d5PlaneC1ERKNS_4Vec3ES3_";
    Constructor :: (this: *Plane, _normal: Vec3, _origin: Vec3) #no_context {
        Constructor(this, *_normal, *_origin);
    }
}

Capsule :: struct {
    start:  Vec3;
    end:    Vec3;
    radius: float;

    Constructor :: (this: *Capsule, _start: *Vec3, _end: *Vec3, _radius: float) -> void #cpp_method #foreign im3d "_ZN4Im3d7CapsuleC1ERKNS_4Vec3ES3_f";
    Constructor :: (this: *Capsule, _start: Vec3, _end: Vec3, _radius: float) #no_context {
        Constructor(this, *_start, *_end, _radius);
    }
}

// Ray-primitive intersections. Use Intersects() when you don't need t.
Intersects :: (_ray: *Ray, _plane: *Plane) -> bool #foreign im3d "_ZN4Im3d10IntersectsERKNS_3RayERKNS_5PlaneE";
Intersects :: (_ray: Ray, _plane: Plane) -> bool #no_context {
    return Intersects(*_ray, *_plane);
}
Intersect :: (_ray: *Ray, _plane: *Plane, t0_: *float) -> bool #foreign im3d "_ZN4Im3d9IntersectERKNS_3RayERKNS_5PlaneERf";
Intersect :: (_ray: Ray, _plane: Plane, t0_: *float) -> bool #no_context {
    return Intersect(*_ray, *_plane, t0_);
}
Intersects :: (_ray: *Ray, _sphere: *Sphere) -> bool #foreign im3d "_ZN4Im3d10IntersectsERKNS_3RayERKNS_6SphereE";
Intersects :: (_ray: Ray, _sphere: Sphere) -> bool #no_context {
    return Intersects(*_ray, *_sphere);
}
Intersect :: (_ray: *Ray, _sphere: *Sphere, t0_: *float, t1_: *float) -> bool #foreign im3d "_ZN4Im3d9IntersectERKNS_3RayERKNS_6SphereERfS6_";
Intersect :: (_ray: Ray, _sphere: Sphere, t0_: *float, t1_: *float) -> bool #no_context {
    return Intersect(*_ray, *_sphere, t0_, t1_);
}
Intersects :: (_ray: *Ray, _capsule: *Capsule) -> bool #foreign im3d "_ZN4Im3d10IntersectsERKNS_3RayERKNS_7CapsuleE";
Intersects :: (_ray: Ray, _capsule: Capsule) -> bool #no_context {
    return Intersects(*_ray, *_capsule);
}
Intersect :: (_ray: *Ray, _capsule: *Capsule, t0_: *float, t1_: *float) -> bool #foreign im3d "_ZN4Im3d9IntersectERKNS_3RayERKNS_7CapsuleERfS6_";
Intersect :: (_ray: Ray, _capsule: Capsule, t0_: *float, t1_: *float) -> bool #no_context {
    return Intersect(*_ray, *_capsule, t0_, t1_);
}

// Find point t0_ along _line0 nearest to _line1 and t1_ along _line1 nearest to _line0.
Nearest :: (_line0: *Line, _line1: *Line, t0_: *float, t1_: *float) -> void #foreign im3d "_ZN4Im3d7NearestERKNS_4LineES2_RfS3_";
Nearest :: (_line0: Line, _line1: Line, t0_: *float, t1_: *float) #no_context {
    Nearest(*_line0, *_line1, t0_, t1_);
}

// Find point tr_ along _ray nearest to _line and tl_ along _line nearest to _ray.
Nearest :: (_ray: *Ray, _line: *Line, tr_: *float, tl_: *float) -> void #foreign im3d "_ZN4Im3d7NearestERKNS_3RayERKNS_4LineERfS6_";
Nearest :: (_ray: Ray, _line: Line, tr_: *float, tl_: *float) #no_context {
    Nearest(*_ray, *_line, tr_, tl_);
}

// Find point tr_ along _ray nearest to _segment, return point on segment nearest to _ray.
Nearest :: (_ray: *Ray, _segment: *LineSegment, tr_: *float) -> Vec3 #foreign im3d "_ZN4Im3d7NearestERKNS_3RayERKNS_11LineSegmentERf";
Nearest :: (_ray: Ray, _segment: LineSegment, tr_: *float) -> Vec3 #no_context {
    return Nearest(*_ray, *_segment, tr_);
}

Distance2 :: (_ray: *Ray, _segment: *LineSegment) -> float #foreign im3d "_ZN4Im3d9Distance2ERKNS_3RayERKNS_11LineSegmentE";
Distance2 :: (_ray: Ray, _segment: LineSegment) -> float #no_context {
    return Distance2(*_ray, *_segment);
}

Pi: float : 3.141593;
TwoPi: float : 2.0 * Pi;
HalfPi: float : 0.5 * Pi;

#scope_file

im3d :: #library "linux/Im3d";
