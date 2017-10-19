------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
---- Dynamic Programming - Pack
------------------------------------------------------------------------------------------------
function PrintItemArr(item_arr)
	local tmp
	for i=1,#item_arr do
		tmp = item_arr[i]
		if type(tmp)=="table" and tmp.cost and tmp.value then
			print("cost = " .. tmp.cost .. " value = " .. tmp.value)
		else
			print(tmp)
		end
	end
end

function InvokeRandom(count)
	while true do
		math.random(1,10000)
		count = count -1
		if count < 1 then
			break
		end
	end
end

function UniqueArr(arr)
	for i=1,#arr do
		for j=#arr,i+1,-1 do
			if arr[i] == arr[j] then
				table.remove(arr, j)
			end
		end
	end
	return arr
end

function RemoveFromArr(arr, item)
	for i=#arr,1,-1 do
		if arr[i]==item then
			table.remove(arr, i)
		end
	end
end

function CopyArr(src_arr, des_arr)
	for i=1,#src_arr do
		des_arr[i] = src_arr[i]
	end
end

function Item(cost, value)
	local item = {}
	item.cost = cost
	item.value = value
	return item
end

function GenItemArr(size)
	local arr = {}
	local tmp
	for i=1,size do
		tmp = Item(math.random(1,100), math.random(1, 200))
		table.insert(arr, tmp)
	end
	return arr
end

function MaxWealth_V1(item_arr, record, item_idx, capacity)
	local item = item_arr[item_idx]
	local wealth
	if item_idx == 1 then
		wealth = item.value
	else
		local wealth_not_select = MaxWealth_V1(item_arr, record, item_idx-1, capacity)
		local wealth_select = MaxWealth_V1(item_arr, record, item_idx-1, capacity-item.cost) + item.value
		if wealth_select>wealth_not_select then
			table.insert(record, item)
			wealth = wealth_select
		else
			wealth = wealth_not_select
			RemoveFromArr(record, item)
		end
	end
	return wealth
end

function MaxWealth_V2(item_arr, record, item_idx, capacity)
	local wealth = {}
	for i=0,#item_arr do
		for j=0,capacity do
			if not wealth[i] then
				wealth[i] = {}
				record[i] = {}
			end
			wealth[i][j] = 0
			record[i][j] = {}
		end
	end

	for i=1,#item_arr do
		local cur_cost = item_arr[i].cost
		for j=0,cur_cost do
			wealth[i][j] = wealth[i-1][j]
		end

		local cur_value = item_arr[i].value
		for j=cur_cost,capacity do
			local wealth_not_select = wealth[i-1][j]
			local wealth_select = wealth[i-1][j-cur_cost] + cur_value
			if wealth_not_select < wealth_select then
				wealth[i][j] = wealth_select
				record[i][j] = 1
			else
				wealth[i][j] = wealth_not_select
			end
		end
	end
	return wealth[#item_arr][capacity]
end

function MaxWealth_V3(item_arr, record, item_idx, capacity)
	local wealth = {}
	for i=0,#item_arr do
		for j=0,capacity do
			if not record[i] then
				record[i] = {}
			end
			record[i][j] = 0
		end
	end
	for i=0,capacity do
		wealth[i] = 0
	end

	for i=1,#item_arr do
		for j=capacity,item_arr[i].cost,-1 do
			local wealth_not_select = wealth[j]
			local wealth_select = wealth[j-item_arr[i].cost]+item_arr[i].value
			if wealth_not_select<wealth_select then
				wealth[j] = wealth_select
				record[i][j] = 1
			else
				wealth[j] = wealth_not_select
			end
		end
	end
	return wealth[capacity]
end

function DoSelect(item_arr)
	local min = item_arr[1]
	local max_cost = 0
	for i=1,#item_arr do
		max_cost = max_cost + item_arr[i].cost
	end

	local record = {}
	local quarter_max_cost = math.floor(max_cost/4)
	local capacity = math.random(quarter_max_cost*2, quarter_max_cost*3)
	print("capacity = " .. capacity)
	local max_wealth
	--max_wealth = MaxWealth_V1(item_arr, record, #item_arr, capacity)
	--max_wealth = MaxWealth_V2(item_arr, record, #item_arr, capacity)
	max_wealth = MaxWealth_V3(item_arr, record, #item_arr, capacity)
	print("max wealth = " .. max_wealth)
	-- print path
	print("path ---- ")
	local j = capacity
	for i=#item_arr,1,-1 do
		if record[i][j]==1 then
			print(i)
			j = j - item_arr[i].cost
		end
	end
	return record
end

InvokeRandom(2)
local item_arr = GenItemArr(3)
local result
print("RawItems--------------------")
PrintItemArr(item_arr)
print("ItemsInBag--------------------")
PrintItemArr(UniqueArr(DoSelect(item_arr)))
