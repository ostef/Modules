AllocOrNull :: inline (size : s64, allocator := context.allocator) -> *void #must
{
    Assert (allocator.proc != null);

    if size <= 0
        return null;

    return allocator.proc (.ALLOCATE, size, 0, null, allocator.data);
}

Alloc :: inline (size : s64, allocator := context.allocator) -> *void #must
{
    Assert (allocator.proc != null);

    if size <= 0
        return null;

    ptr := allocator.proc (.ALLOCATE, size, 0, null, allocator.data);
    Assert (ptr != null, "Allocator % could not allocate % bytes", GetAllocatorName (allocator), size);

    #if Basic.MEMORY_DEBUGGER
        Basic.Memory_Debugger.check_alloc (allocator, ptr, size);

    return ptr;
}

Alloc :: inline ($T : Type, allocator := context.allocator, $initialize := true) -> *T #must
{
    ptr := cast (*T) Alloc (size_of (T), allocator);
    #if initialize
        Initialize (ptr);

    return ptr;
}

Alloc :: inline ($T : Type, count : s64, allocator := context.allocator, $initialize := false) -> *T #must
{
    ptr := cast (*T) Alloc (size_of (T) * count, allocator);
    #if initialize
        Initialize (ptr, count);

    return ptr;
}

AllocArray :: inline ($T : Type, count : s64, allocator := context.allocator, $initialize := false) -> []T #must
{
    result : []T = ---;
    result.data = Alloc (T, count, allocator, initialize);
    result.count = count;

    return result;
}

Free :: inline (ptr : *void, allocator := context.allocator)
{
    Assert (allocator.proc != null);

    if !ptr
        return;

    #if Basic.MEMORY_DEBUGGER
        Basic.Memory_Debugger.check_free (allocator, ptr);

    allocator.proc (.FREE, 0, 0, ptr, allocator.data);
}

Realloc :: inline (ptr : *void, old_size : s64, size : s64, allocator := context.allocator) -> *void #must
{
    Assert (allocator.proc != null);

    new_ptr := allocator.proc (.RESIZE, size, old_size, ptr, allocator.data);
    Assert (new_ptr != null, "Allocator % failed to reallocate % bytes (previous size was %)", GetAllocatorName (allocator), size, old_size);

    #if Basic.MEMORY_DEBUGGER
        Basic.Memory_Debugger.check_realloc (allocator, ptr, old_size, new_ptr, size);

    return new_ptr;
}

GetAllocatorName :: inline (allocator := context.allocator) -> string #must
{
    name : string;
    allocator.proc (.CAPS, 0, 0, *name, allocator.data);

    return name;
}

GetAllocatorSpecs :: inline (allocator := context.allocator) -> Allocator_Caps #must
{
    return cast, no_check (Allocator_Caps) allocator.proc (.CAPS, 0, 0, null, allocator.data);
}

Trap :: Allocator.{ proc = TrapAllocatorProc, data = null };

TrapAllocatorProc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void
{
    Panic ("Allocation trap");

    return null;
}

AllocatorScope :: (allocator : Allocator) #expand
{
    prev := context.allocator;
    context.allocator = allocator;
    `defer context.allocator = prev;
}

#scope_module

Basic :: #import "Basic";

#scope_export

Temp :: Basic.temp;

Temporary_Storage_State :: Basic.Temporary_Storage_State;

TemporaryAlloc :: Basic.temporary_allocator_proc;
GetTemporaryStorageState :: Basic.get_temporary_storage_mark;
SetTemporaryStorageState :: Basic.set_temporary_storage_mark;
ResetTemporaryStorage :: Basic.reset_temporary_storage;

TemporaryStorageScope :: () #expand
{
    state := GetTemporaryStorageState ();
    defer `SetTemporaryStorageState (state);
}
