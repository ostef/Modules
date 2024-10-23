MakeArray :: inline (count : s64, data : *$T) -> []T #must
{
    arr : []T = ---;
    arr.count = count;
    arr.data = data;

    return arr;
}

ArrayClone :: inline (arr : []$T) -> []T #must
{
    result := AllocArray(T, arr.count);
    memcpy(result.data, arr.data, size_of(T) * arr.count);

    return result;
}

ArraySlice :: inline (arr : []$T, start : s64, count : s64) -> []T #must
{
    res : []T = ---;
    res.data = arr.data + Clamp(start, 0, arr.count);
    res.count = Clamp(count, 0, arr.count - start);

    return res;
}

ArrayTruncate :: inline (arr : []$T, count : s64) -> []T #must
{
    count = Clamp(count, 0, arr.count);

    res : []T = ---;
    res.data = arr.data;
    res.data = arr.count - count;

    return res;
}

ArrayAdvance :: inline (arr : []$T, count : s64) -> []T #must
{
    count = Clamp(count, 0, arr.count);

    res : []T = ---;
    res.data = arr.data + count;
    res.data = arr.count - count;

    return res;
}

ArrayFree :: inline (arr : *[..]$T)
{
    Free(arr.data,, arr.allocator);
    arr.data = null;
    arr.count = 0;
    arr.allocated = 0;
}

ArrayClear :: inline (arr : *[..]$T)
{
    arr.count = 0;
}

ArrayReserve :: inline (arr : *[..]$T, new_capacity : s64)
{
    if !arr.allocator.proc
        arr.allocator = context.allocator;

    if new_capacity <= arr.allocated
        return;

    new_data := cast(*T) Realloc(arr.data, arr.allocated * size_of(T), new_capacity * size_of(T),, arr.allocator);
    arr.data = new_data;
    arr.allocated = new_capacity;
}

ArrayTop :: inline (arr : []$T) -> *T #must
{
    Assert(arr.count > 0);

    return *arr.data[arr.count - 1];
}

ArrayPush :: inline (arr : *[..]$T, $initialize := true) -> *T #must
{
    if arr.count >= arr.allocated
        ArrayReserve(arr, arr.allocated * 2 + 8);

    ptr := *arr.data[arr.count];
    arr.count += 1;
    #if initialize
        Initialize(ptr);

    return ptr;
}

ArrayPush :: inline (arr : *[..]$T, elem : T) -> *T
{
    ptr := ArrayPush(arr, initialize = false);
    ptr.* = elem;

    return ptr;
}

ArrayPushMultiple :: inline (arr : *[..]$T, elems : []T)
{
    if arr.count + elems.count > arr.allocated
        ArrayReserve(arr, arr.allocated * 2 + elems.count);

    memcpy(arr.data + arr.count, elems.data, size_of(T) * elems.count);
    arr.count += elems.count;
}

ArrayPop :: inline (arr : *[..]$T)
{
    Assert(arr.count > 0, "Popping empty array");

    arr.count -= 1;
}

ArrayInsert :: inline (arr : *[..]$T, index : s64, $initialize := true) -> *T #must
{
    Assert(index >= 0 && index <= arr.count, "Index out of bounds (index is %, bounds are [0, %])", index, arr.count);

    if arr.count >= arr.allocated
        ArrayReserve(arr, arr.allocated * 2 + 8);

    arr.data[arr.count] = arr.data[index];
    arr.count += 1;

    ptr := *arr.data[index];
    #if initialize
        Initialize(ptr);

    return ptr;
}

ArrayInsert :: inline (arr : *[..]$T, index : s64, elem : T) -> *T
{
    ptr := ArrayInsert(arr, index, initialize = false);
    ptr.* = elem;

    return ptr;
}

ArrayRemove :: inline (arr : *[..]$T, index : s64)
{
    Assert(index >= 0 && index < arr.count, "Index out of bounds (index is %, bounds are [0, %])", index, arr.count - 1);

    arr.count -= 1;
    arr.data[index] = arr.data[arr.count];
}

ArrayOrderedInsert :: inline (arr : *[..]$T, index : s64, $initialize := true) -> *T #must
{
    Assert(index >= 0 && index <= arr.count, "Index out of bounds (index is %, bounds are [0, %])", index, arr.count);

    if arr.count >= arr.allocated
        ArrayReserve(arr, arr.allocated * 2 + 8);

    arr.count += 1;
    for < i : arr.count - 1..index + 1
    {
        arr.data[i] = arr.data[i - 1];
    }

    ptr := *arr.data[index];
    #if initialize
        Initialize(ptr);

    return ptr;
}

ArrayOrderedInsert :: inline (arr : *[..]$T, index : s64, elem : T) -> *T
{
    ptr := ArrayOrderedInsert(arr, index, initialize = false);
    ptr.* = elem;

    return ptr;
}

ArrayOrderedRemove :: inline (arr : *[..]$T, index : s64)
{
    Assert(index >= 0 && index < arr.count, "Index out of bounds (index is %, bounds are [0, %])", index, arr.count - 1);

    memcpy(arr.data + index, arr.data + index + 1, size_of(T) * (arr.count - index - 1));
    arr.count -= 1;
}

ArrayGetIndex :: inline (arr : []$T, item : *T) -> s64 #must
{
    if item >= arr.data && item < arr.data + arr.count
        return item - arr.data;

    return -1;
}

ArrayFindFirst :: (arr : []$T, item : T, $compare : (T, T) -> bool = (a, b) => a == b) -> s64 #must
{
    for arr
    {
        if compare(it, item)
            return it_index;
    }

    return -1;
}

ArrayFindLast :: (arr : []$T, item : T, $compare : (T, T) -> bool = (a, b) => a == b) -> s64 #must
{
    for < arr
    {
        if compare(it, item)
            return it_index;
    }

    return -1;
}

ArrayPushUnique :: (arr : *[..]$T, item : T) -> bool
{
    if ArrayFindFirst(arr.*, item) == -1
    {
        ArrayPush(arr, item);
        return true;
    }

    return false;
}
