------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
-- Quick Sorting
function Partition(arr, p, q)
    local temp
    local i = p
    for j=p+1,q do
        if arr[j] <= arr[p] then
            i=i+1
            temp = arr[i]
            arr[i] = arr[j]
            arr[j] = temp
        end
    end
    temp = arr[i]
    arr[i] = arr[p]
    arr[p] = temp
    return i
end

function QuickSort(arr, p, q)
    if p<0 or p>=q then
        return
    end

    local i = Partition(arr, p, q)
    QuickSort(arr, p, i-1)
    QuickSort(arr, i+1, q)
end

------------------------------------------------------------------------------------------------
-- Random Quick Sorting
function RandomPartition(arr, p, q)
    local temp
	local i = math.random(p,q)
	temp = arr[i]
	arr[i] = arr[p]
	arr[p] = temp

	i = p
    for j=p+1,q do
        if arr[j] <= arr[p] then
            i=i+1
            temp = arr[i]
            arr[i] = arr[j]
            arr[j] = temp
        end
    end

    temp = arr[i]
    arr[i] = arr[p]
    arr[p] = temp
    return i
end

function RandomQuickSort(arr, p, q)
	if p<0 or p>=q then
        return
    end

    i = RandomPartition(arr, p, q)
    RandomQuickSort(arr, p, i-1)
    RandomQuickSort(arr, i+1, q)
end

------------------------------------------------------------------------------------------------
-- Heap Sorting
-- 请参考 Heap_example.lua

local arr = {12,2,8,1,3,11,9,7}
--QuickSort(arr,1,#arr)
RandomQuickSort(arr,1,#arr)
for i=1,#arr do
    print(arr[i])
end
