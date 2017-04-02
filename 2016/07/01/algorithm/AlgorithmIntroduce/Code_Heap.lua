------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
------------------------------------------------------------------------------------------------
function Heapify(h, hSize, i, isMaxPriority)
    if i<1 or i>#h then
        print("ERROR index out of range")
        return
    end
    local pIdx = nil
    local choosed = nil
    local isChoosedL = nil
    local lIdx = nil
    local rIdx = nil
    if i<hSize then
        lIdx = 2*i
        if lIdx>hSize then
            return
        end
        rIdx = lIdx+1
        if rIdx>hSize then
            rIdx = nil
        end
        choosed = h[lIdx]
        isChoosedL = true
        if rIdx then
            if isMaxPriority then
                if h[lIdx]<h[rIdx] then
                    choosed = h[rIdx]
                    isChoosedL = false
                end
            else
                if h[lIdx]>h[rIdx] then
                    choosed = h[rIdx]
                    isChoosedL = false
                end
            end
        end

        local isNeedProcess = false
        if isMaxPriority then
            isNeedProcess = h[i]<choosed
        else
            isNeedProcess = h[i]>choosed
        end
        if isNeedProcess then
            if isChoosedL then
                h[lIdx] = h[i]
                h[i] = choosed
                i = lIdx
            else
                h[rIdx] = h[i]
				h[i] = choosed
                i = rIdx
            end
            Heapify(h, hSize, i, isMaxPriority)
        end
    end
end

function HeapInsert(h, v, isMaxPriority)
    if h then
        table.insert(h,v)
        local idx = #h
        local pIdx = nil
        local isNeedProcess = false
        local temp = nil
        while idx > 1 do
            pIdx = math.floor(idx/2)
            if isMaxPriority then
                isNeedProcess = h[pIdx]<h[idx]
            else
                isNeedProcess = h[pIdx]>h[idx]
            end
            if isNeedProcess then
                temp = h[idx]
                h[idx] = h[pIdx]
                h[pIdx] = temp
                idx = pIdx
            else
                break
            end
        end
    end
end

function HeapDelete(h, i, isMaxPriority)
    if h and i>0 and i<=#h then
        local v = h[i]
        if i<#h then
            h[i] = h[#h]
            table.remove(h,#h)
            Heapify(h, #h, i, isMaxPriority)
        else
            table.remove(h,#h)
        end
        return v
    else
        print("ERROR - heap is empty")
    end
end

function HeapExtract(h,isMaxPriority)
    return HeapDelete(h,1,isMaxPriority)
end

function HeapBuild(arr, isMaxPriority)
    if arr and #arr>1 then
        local startIdx = math.ceil(#arr/2)
        for i=startIdx,1,-1 do
            Heapify(arr, #arr, i, isMaxPriority)
        end
    end
end

function HeapSort(arr, isReverse)
    HeapBuild(arr, not isReverse)
    local hSize = #arr
    local temp = nil
    while hSize>1 do
        temp = arr[1]
        arr[1]=arr[hSize]
        arr[hSize] = temp
        hSize = hSize-1
        Heapify(arr, hSize, 1, not isReverse)
    end
end

function HeapPrint(h)
    for i=1,#h do
        print(h[i])
    end
end

local arr = {10,2,6,1,4}
HeapSort(arr,true)
HeapPrint(arr)
