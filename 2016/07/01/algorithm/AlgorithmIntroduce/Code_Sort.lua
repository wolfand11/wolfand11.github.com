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

------------------------------------------------------------------------------------------------
-- BubbleSort
function BubbleSort(arr, is_min_to_max)
    local tmp
    for i=1,#arr do
        for j=1,#arr-i do
            if arr[j] > arr[j+1] == is_min_to_max then
                tmp = arr[j]
                arr[j] = arr[j+1]
                arr[j+1] = tmp
            end
        end
    end
    return arr
end

------------------------------------------------------------------------------------------------
-- InsertSort
function InsertSort(arr, is_min_to_max)
    local tmp
    for i=1,#arr do
        for j=i,2,-1 do
            if arr[j-1]>arr[j] == is_min_to_max then
                tmp = arr[j]
                arr[j] = arr[j-1]
                arr[j-1] = tmp
            end
        end
    end
    return arr
end

------------------------------------------------------------------------------------------------
-- MergeSort
function MergeSort(arr, is_min_to_max, start_idx, end_idx)
    if not start_idx then
        start_idx = 1
    end
    if not end_idx then
        end_idx = #arr
    end

    if end_idx <= start_idx then
        return arr
    end

    local mid_idx = math.floor((start_idx+end_idx)/2)
    MergeSort(arr, is_min_to_max, start_idx, mid_idx)
    MergeSort(arr, is_min_to_max, mid_idx+1, end_idx)

    local result = {}
    local part_a_idx = start_idx
    local part_b_idx = mid_idx + 1
    while part_a_idx<=mid_idx or part_b_idx<=end_idx do
        if part_a_idx>mid_idx then
            for i=part_b_idx,end_idx do
                table.insert(result, arr[i])
            end
            break
        end
        if part_b_idx>end_idx then
            for i=part_a_idx,mid_idx do
                table.insert(result, arr[i])
            end
            break
        end
        if arr[part_a_idx]<arr[part_b_idx]==is_min_to_max then
            table.insert(result, arr[part_a_idx])
            part_a_idx = part_a_idx + 1
        else
            table.insert(result, arr[part_b_idx])
            part_b_idx = part_b_idx + 1
        end
    end
    for i=start_idx,end_idx do
        arr[i] = result[i-start_idx+1]
    end

    return arr
end

------------------------------------------------------------------------------------------------
-- QuickSort and RandomQuickSort
function GetParting1Func(is_random)
    function Parting1(arr, is_min_to_max, start_idx, end_idx)
        local selected_idx = end_idx
        if is_random then
            selected_idx = math.random(start_idx, end_idx)
        end

        local tmp
        while start_idx~=end_idx do
            if start_idx<selected_idx then
                if arr[start_idx]<arr[selected_idx]==is_min_to_max or arr[start_idx]==arr[selected_idx] then
                    start_idx = start_idx+1
                else
                    tmp = arr[selected_idx]
                    arr[selected_idx] = arr[start_idx]
                    arr[start_idx] = tmp

                    selected_idx = start_idx
                end
            else
                if arr[selected_idx]<arr[end_idx]==is_min_to_max or arr[end_idx]==arr[selected_idx] then
                    end_idx = end_idx-1
                else
                    tmp = arr[selected_idx]
                    arr[selected_idx] = arr[end_idx]
                    arr[end_idx] = tmp

                    selected_idx = end_idx
                end
            end
        end
        return selected_idx
    end
    return Parting1;
end

function GetParting2Func(is_random)
    function Parting2(arr, is_min_to_max, start_idx, end_idx)
        local tmp
        local i = start_idx
        if is_random then
            i = math.random(start_idx, end_idx)
            tmp = arr[i]
            arr[i] = arr[start_idx]
            arr[start_idx] = tmp
            i = start_idx
        end

        for j=start_idx+1,end_idx do
            if arr[j]<arr[start_idx]==is_min_to_max then
                i = i + 1
                tmp = arr[i]
                arr[i] = arr[j]
                arr[j] = tmp
            end
        end
        tmp = arr[start_idx]
        arr[start_idx] = arr[i]
        arr[i] = tmp

        return i
    end
    return Parting2
end

function QuickSort(arr, is_min_to_max, parting_func, start_idx, end_idx)
    if not start_idx then
        start_idx = 1
    end
    if not end_idx then
        end_idx = #arr
    end

    if end_idx <= start_idx then
        return arr
    end

    local mid_idx = parting_func(arr, is_min_to_max, start_idx, end_idx)
    QuickSort(arr, is_min_to_max, parting_func, start_idx, mid_idx-1)
    QuickSort(arr, is_min_to_max, parting_func, mid_idx+1, end_idx)
    return arr
end

local arr = {2,1,7,3,9,2,1,7,3,9,2,1,7,3,9}
--local arr = {2,1,7,3,9}
PrintArr(BubbleSort(arr, true),                         "bubble sort  : ")
PrintArr(InsertSort(arr, false),                        "insert sort  : ")
PrintArr(MergeSort(arr, true),                          "merge sort   : ")
PrintArr(QuickSort(arr, false, GetParting1Func()),      "quick sort1  : ")
PrintArr(QuickSort(arr, true,  GetParting1Func(true)),  "quick sortR1 : ")
PrintArr(QuickSort(arr, false, GetParting2Func()),      "quick sort2  : ")
PrintArr(QuickSort(arr, true,  GetParting2Func(true)),  "quick sortR2 : ")
