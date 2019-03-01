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

------------------------------------------------------------------------------------------------
-- CountingSort
function CountingSort1(arr, is_min_to_max)
    local max=arr[1]
    local space = {}
    for i=1,#arr do
        if max<arr[i] then
            max=arr[i]
        end
        if not space[arr[i]] then
            space[arr[i]] = 1
        else
            space[arr[i]] = space[arr[i]] + 1
        end
    end

    local start_idx
    local end_idx
    local step
    if is_min_to_max then
        start_idx = 1
        end_idx = max
        step = 1
    else
        start_idx = max
        end_idx = 1
        step = -1
    end

    local idx = 1
    for i=start_idx,end_idx,step do
        while space[i] and space[i]>0 do
            arr[idx] = i
            space[i] = space[i] - 1
            idx = idx+1
        end
    end
    return arr
end

-- CountingSort2 是稳定的
function CountingSort2(arr, is_min_to_max)
    local max=arr[1]
    local space = {}
    for i=1,#arr do
        if max<arr[i] then
            max=arr[i]
        end
        if not space[arr[i]] then
            space[arr[i]] = 1
        else
            space[arr[i]] = space[arr[i]] + 1
        end
    end

    local tmp = 0
    for i=1,max do
        if space[i] then
            space[i] = tmp + space[i]
            tmp = space[i]
        end
    end

    local result = {}
--    for i=#arr,1,-1 do
--        result[space[arr[i]]] = arr[i]
--        space[arr[i]] = space[arr[i]] - 1
--    end
    for i=1,#arr do
        result[space[arr[i]]] = arr[i]
        space[arr[i]] = space[arr[i]] - 1
    end

    for i=1,#result do
        if is_min_to_max then
            arr[i] = result[i]
        else
            arr[i] = result[#result+1-i]
        end
    end
    return arr
end

------------------------------------------------------------------------------------------------
-- RadixSort
function RadixSort(arr, max_digit_number, max_one_digit, is_min_to_max)
    local result = {}
    local tmp
    local counter = {}
    for i=0,max_digit_number-1 do
        for j=1,max_one_digit do
            counter[j] = 0
        end

        for j=1,#arr do
            tmp = math.floor(arr[j] / math.pow(max_one_digit,i))%max_one_digit+1
            counter[tmp] = counter[tmp] + 1
        end

        tmp = 0
        for j=1,max_one_digit do
            if counter[j]>0 then
                counter[j] = counter[j]+tmp
                tmp = counter[j]
            end
        end

        --不能采用注释掉的循环遍历方法，如果元素中包含相同元素时，该循环会破坏元素之间的先后顺序
        --for j=1,#arr do
        for j=#arr,1,-1 do
            tmp = math.floor(arr[j] / math.pow(max_one_digit,i))%max_one_digit+1
            result[counter[tmp]] = arr[j]
            counter[tmp] = counter[tmp]-1
        end

        for j=1,#result do
            arr[j] = result[j]
        end
    end

    if not is_min_to_max then
        for i=1,#result do
            arr[i] = result[#result+1-i]
        end
    end

    return arr
end

------------------------------------------------------------------------------------------------
--BucketSort
function BucketSort(arr, bucket_size, is_min_to_max)
    local max=arr[1]
    local buckets = {}
    for i=1,#arr do
        if max<arr[i] then
            max=arr[i]
        end
    end

    local tmp
    local bucket_idx
    for i=1,#arr do
        tmp = arr[i]/max
        for j=1,bucket_size do
            bucket_idx_l = math.floor(j/bucket_size*100)*0.01
            bucket_idx_r = math.floor((j+1)/bucket_size*100)*0.01
            if tmp>=bucket_idx_l and tmp < bucket_idx_r then
                if not buckets[bucket_idx_l] then
                    buckets[bucket_idx_l] = {}
                end
                table.insert(buckets[bucket_idx_l],arr[i])
            end
        end
    end

    for k,v in pairs(buckets) do
        table.sort(v)
    end

    tmp = 1
    for i=1,bucket_size do
        bucket_idx = math.floor(i/bucket_size*100)*0.01
        if buckets[bucket_idx] then
            for j=1,#(buckets[bucket_idx]) do
                arr[tmp] = buckets[bucket_idx][j]
                tmp = tmp + 1
            end
        end
    end

    if not is_min_to_max then
        local head = 1
        local tail = #arr
        while head<tail do
            tmp = arr[head]
            arr[head] = tail
            arr[tail] = tmp
            head = head+1
            tail = tail-1
        end
    end
    return arr
end

--local arr = {2,1,7,3,9,2,1,7,3,9,2,1,7,3,9}
--local arr = {2,1,7,3,9}
local arr = {329,457,657,839,436,720,355,329,457,657,839,436,720,355}
PrintArr(BubbleSort(arr, true),                         "bubble sort  : ")
PrintArr(InsertSort(arr, false),                        "insert sort  : ")
PrintArr(MergeSort(arr, true),                          "merge sort   : ")
PrintArr(QuickSort(arr, false, GetParting1Func()),      "quick sort1  : ")
PrintArr(QuickSort(arr, true,  GetParting1Func(true)),  "quick sortR1 : ")
PrintArr(QuickSort(arr, false, GetParting2Func()),      "quick sort2  : ")
PrintArr(QuickSort(arr, true,  GetParting2Func(true)),  "quick sortR2 : ")
PrintArr(CountingSort1(arr, false),                     "count sort1  : ")
PrintArr(CountingSort2(arr, true),                      "count sort2  : ")
PrintArr(RadixSort(arr, 3, 10, false),                  "radix sort   : ")
PrintArr(BucketSort(arr, 10, true),                     "backet sort  : ")
