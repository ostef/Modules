#module_parameters (Enable_Profiling := true);

#import "Common";
#import "Hash_Map";

#scope_file

Basic :: #import "Basic";
using, only (.["+", "-", "*", "/"]) Basic;

Threads :: #import "Thread";
Hash :: #import "Hash";

operator== :: inline (a : Source_Code_Location, b : Source_Code_Location) -> bool
{
    return a.fully_pathed_filename == b.fully_pathed_filename
        && a.line_number == b.line_number
        && a.character_number == b.character_number;
}

#scope_export

ProfilingEntriesMap :: HashMap (
    ProfilingKey, ProfilingData,
    hash_func = (key) => Hash.sdbm_hash (*key, size_of (ProfilingKey)),
    comp_func = (a, b) => a == b
);

#scope_file

g_global_profiling_data : ProfilingEntriesMap;
g_global_profiling_mutex : Threads.Mutex;

#scope_export

ProfilingKey :: struct
{
    location : Source_Code_Location;
    proc_name : string;
    name : string;
}

operator== :: inline (a : ProfilingKey, b : ProfilingKey) -> bool #must
{
    return a.location == b.location
        && a.proc_name == b.proc_name
        && a.name == b.name;
}

ProfilingData :: struct
{
    using key : ProfilingKey;
    number_of_times_profiled : int;
    total_time : Basic.Apollo_Time;
}

ProfilingInit :: ()
{
    Threads.init (*g_global_profiling_mutex, "Global Profiling Data");
    HashMapInit (*g_global_profiling_data, 100);
}

LockGlobalProfilingData :: inline () -> *ProfilingEntriesMap #must
{
    Threads.lock (*g_global_profiling_mutex);

    return *g_global_profiling_data;
}

UnlockGlobalProfilingData :: inline ()
{
    Threads.unlock (*g_global_profiling_mutex);
}

CopyProfilingData :: (dest : *ProfilingEntriesMap, source : ProfilingEntriesMap)
{
    for source
    {
        ptr, is_new := HashMapInsert (dest, it_index);
        ptr.key = it_index;
        ptr.total_time += it.total_time;
        ptr.number_of_times_profiled += it.number_of_times_profiled;
    }
}

AddGlobalProfilingData :: (entries : *ProfilingEntriesMap, free_entries := true)
{
    if entries.count == 0
        return;

    global_entries := LockGlobalProfilingData ();
    defer UnlockGlobalProfilingData ();

    CopyProfilingData (global_entries, entries);

    if free_entries
        HashMapFree (entries);
}

#add_context profiling_entries : ProfilingEntriesMap;

GetProfilingData :: inline (proc_name : string, name : string, location : Source_Code_Location) -> *ProfilingData #must
{
    ptr, new := HashMapInsert (*context.profiling_entries, .{location, proc_name, name});
    ptr.key = .{location, proc_name, name};

    return ptr;
}

ProfileBlock :: (name := "", divide_by := 0, location := #caller_location) #expand
{
    #if Enable_Profiling
    {
        start_time := Basic.current_time_monotonic ();

        `defer {
            end_time := Basic.current_time_monotonic ();

            data := GetProfilingData (#procedure_name (), name, location);
            if divide_by > 0
                data.total_time += (end_time - start_time) / divide_by;
            else
                data.total_time += end_time - start_time;

            data.number_of_times_profiled += 1;
        };
    }
}

PrintProfilingData :: (builder : *StringBuilder, using data : ProfilingData)
{
    if name
        StringBuilderAppendLine (builder, "% - %    (%:%:%)",
            proc_name, name, location.fully_pathed_filename, location.line_number, location.character_number);
    else
        StringBuilderAppendLine (builder, "%    (%:%:%)",
            proc_name, location.fully_pathed_filename, location.line_number, location.character_number);

    avg_time_secs := Basic.to_float64_seconds (total_time / number_of_times_profiled);

    avg_time_fmt : FormatFloat;
    avg_time_fmt.value = avg_time_secs;
    avg_time_fmt.trailing_width = 3;
    avg_time_fmt.zero_removal = .NO;
    unit := " s";

    if avg_time_secs < 1 / (1000.0 * 1000.0)
    {
        avg_time_fmt.value = avg_time_secs * 1000.0 * 1000.0 * 1000.0;
        unit = "ns";
    }
    else if avg_time_secs < 1 / 1000.0
    {
        avg_time_fmt.value = avg_time_secs * 1000.0 * 1000.0;
        unit = "μs";
    }
    else if avg_time_secs < 1
    {
        avg_time_fmt.value = avg_time_secs * 1000.0;
        unit = "ms";
    }

    StringBuilderAppendLine (builder, "% %, profiled % times",
            avg_time_fmt, unit, number_of_times_profiled);
}

PrintProfilingData :: (builder : *StringBuilder, entries : ProfilingEntriesMap)
{
    Sort :: #import "Sort";

    sorted_entries : [..]ProfilingData;
    for entries
        ArrayPush (*sorted_entries, it);

    Sort.quick_sort (sorted_entries, (a : ProfilingData, b : ProfilingData) -> int
    {
        result := StringCompare (a.proc_name, b.proc_name);
        if result == 0
            return StringCompare (a.name, b.name);

        return result;
    });

    for sorted_entries
    {
        PrintProfilingData (builder, it);
        StringBuilderAppend (builder, "\n");
    }
}
