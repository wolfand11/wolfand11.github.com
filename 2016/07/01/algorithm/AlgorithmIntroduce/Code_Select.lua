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
-- Select and RandomSelect
function GetPartingFunc(is_random)
	function Parting (arr, start_idx, end_idx)
		local tmp
		local i=start_idx
		if is_random then
			i = math.random(start_idx, end_idx)
			tmp = arr[i]
			arr[i] = arr[start_idx]
			arr[start_idx] = tmp
			i = start_idx
		end
		local choosed_v = arr[start_idx]
		for j=start_idx, end_idx do
			if arr[j]<choosed_v then
				i = i+1
				tmp = arr[i]
				arr[i] = arr[j]
				arr[j] = tmp
			end
		end
		tmp = arr[i]
		arr[i] = arr[start_idx]
		arr[start_idx] = tmp
		return i
	end
	return Parting;
end

function Select(arr, order, parting_func, start_idx, end_idx)
	if not start_idx then
		start_idx = 1
	end
	if not end_idx then
		end_idx = #arr
	end

	if order<start_idx or order>end_idx then
		print(string.format("order(%s) is out range![%s,%s]", order, start_idx, end_idx))
		return nil
	end

	local idx = parting_func(arr,start_idx,end_idx)
	if idx==order then
		return arr[idx]
	elseif idx<order then
		return Select(arr, order, parting_func, idx+1, end_idx)
	else
		return Select(arr, order, parting_func, start_idx, idx-1)
	end
end

local arr = {329,457,657,839,436,720,355}
PrintArr(arr,       "raw arr         : ")
print(string.format("select i        : %s", Select(arr, 4, GetPartingFunc(false))))
print(string.format("random-select i : %s", Select(arr, 4, GetPartingFunc(true))))
table.sort(arr)
PrintArr(arr, 		"sorted arr      : ")
