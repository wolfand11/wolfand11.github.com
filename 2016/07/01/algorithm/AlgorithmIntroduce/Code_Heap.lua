------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
------------------------------------------------------------------------------------------------
function PrintArr(arr, msg)
    if not msg then
        msg = ""
    end

    for i=1,#arr do
        msg = msg .. arr[i] .. " "
    end
    print(msg)
end

function HeapBuild(arr, is_max)
    for i=math.floor(#arr/2),1,-1 do
        Heapify(arr, i, #arr, is_max)
    end
end

function Heapify(arr, root_idx, end_idx, is_max)
    local l_idx = root_idx*2
    local r_idx = l_idx + 1
    local max_or_min_idx
    local tmp
    if l_idx<=end_idx then
        if r_idx>end_idx then
            r_idx = l_idx
        end

        max_or_min_idx = r_idx
        if arr[r_idx] < arr[l_idx] == is_max then
            max_or_min_idx = l_idx
        end
        if arr[max_or_min_idx] > arr[root_idx] == is_max then
            tmp = arr[max_or_min_idx]
            arr[max_or_min_idx] = arr[root_idx]
            arr[root_idx] = tmp

            Heapify(arr, max_or_min_idx, end_idx, is_max)
        end
    end
end

function HeapSort(arr, is_min_to_max)
    HeapBuild(arr, is_min_to_max)

    local tmp
    local i = #arr
    while i > 1 do
        tmp = arr[1]
        arr[1] = arr[i]
        arr[i] = tmp

        i = i-1
        Heapify(arr, 1, i, is_min_to_max)
    end
end

function HeapInsert(arr, v, is_max)
    table.insert(arr, v)
    local i=math.floor(#arr/2)
    while i>0 do
        Heapify(arr, i, #arr, is_max)
        i = math.floor(i/2)
    end
end

function HeapDelete(arr, idx, is_max)
    if idx>0 and idx<=#arr then
        local deleted_v = arr[idx]
        arr[idx] = arr[#arr]
        table.remove(arr,#arr)
        Heapify(arr, idx, #arr, is_max)
        return deleted_v
    else
        print("idx(%s) out of rang(1,%s)!", idx, #arr)
    end
end

function HeapExtract(arr, is_max)
    return HeapDelete(arr, 1, is_max)
end

--local arr = {2,1,7,3,9,2,1,7,3,9,2,1,7,3,9}
local arr = {2,1,7,3,9}
PrintArr(arr, "raw arr      : ")
HeapBuild(arr, true)
PrintArr(arr, "heap build   : ")
HeapInsert(arr, 10, true)
PrintArr(arr, "heap insert  : ")
HeapDelete(arr,2,true)
PrintArr(arr, "heap delete  : ")
HeapExtract(arr,true)
PrintArr(arr, "heap extract : ")
HeapSort(arr, true)
PrintArr(arr, "heap sort    : ")
