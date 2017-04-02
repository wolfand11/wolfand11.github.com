------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
-- Longest Common Subsequence
-- 暴力穷举法解决问题
function LCS_Normal(s1, s2)
    local lcsLen = 0
    local idx = 0
    local subSeqDecimal = 0
    local subSeq = nil
    local result = {}
    local isCommonSubseq = false

    local codeTimer = os.clock()
    for i=1,math.pow(2,#s1) do
        subSeqDecimal = i
        subSeq = {}
        idx = 1
        while true do
            if subSeqDecimal % 2 == 1 then
                table.insert(subSeq,s1[idx])
            end
            -- right move binary steam
            subSeqDecimal = math.floor(subSeqDecimal/2)
            idx = idx+1
            if subSeqDecimal<1 then
                break
            end
        end

        idx = 1
        isCommonSubseq = false
        for j=1,#s2 do
            if s2[j] == subSeq[idx] then
                idx = idx + 1
                if idx>#subSeq then
                    isCommonSubseq = true
                    break
                end
            end
        end
        if isCommonSubseq then
            if #subSeq >= lcsLen then
                lcsLen = #subSeq
                if result[lcsLen]==nil then
                    result[lcsLen] = {}
                end
                table.insert(result[lcsLen],subSeq)
            end
        end
    end
    print("LCS_Normal invoke delta time = " .. tostring(os.clock()-codeTimer) .. " len(s1) = " .. #s1)
    return result[lcsLen]
end

function LCS(s1,s2,i,j,lcs)
    if i>0 and j>0 then
        if s1[i] == s2[j] then
            table.insert(lcs,s1[i])
            LCS(s1,s2,i-1,j-1,lcs)
            return true
        elseif LCS(s1,s2,i-1,j,lcs)==false then
            LCS(s1,s2,i,j-1,lcs)
        end
    end
    return false
end

function PrintArr(arr)
    local result = ""
    for i=1,#arr do
        result = result .. tostring(arr[i])
        result = result .. " "
    end
    print(result)
end

local s1 = {2,1,6,7,9,0,1,7}
local s2 = {9,6,9,0,1,6,7,9}
local lcsArr = LCS_Normal(s1, s2)
if lcsArr then
    for i=1,#lcsArr do
        PrintArr(lcsArr[i])
    end
end

local lcs = {}
LCS(s1,s2,#s1,#s2,lcs)
PrintArr(lcs)
