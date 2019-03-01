------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
------------------------------------------------------------------------------------------------
function PrintHashTable(hash_table, msg)
	if not msg then
		msg = ""
	end
	print(msg .. "-----START")
	for k,v in pairs(hash_table) do
		if k~="_hash_args" then
			print("-- hash_key " .. k)
			while v do
				print(string.format("%s - %s",v.key,v.value))
				v = v.next
			end
		end
	end
	print(msg .. "-----END")
end

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
-- Node
function Node (key, value)
	local node = {}
	node.key = key
	node.value = value
	node.next = nil
	node.mark = false
	return node
end
------------------------------------------------------------------------------------------------
-- ChainedHashTable
local ChainedHashTable = {}
ChainedHashTable.__index = function (tbl, key)
  return ChainedHashTable[key]
end
function ChainedHashTable.New(hash_func_chooser, max_load_factor, bucket_count, max_key)
	local hash_table = {}
	setmetatable(hash_table, ChainedHashTable)
	hash_table._hash_args = {}
	hash_table._hash_args._size = 0
	hash_table._hash_args._max_key = max_key
	hash_table._hash_args._max_load_factor = 1
	hash_table._hash_args._bucket_count = bucket_count
	hash_table._hash_args._hash_func_chooser = hash_func_chooser
	hash_table._hash_args._hash_func = hash_func_chooser(bucket_count, max_key)
	hash_table._hash_args._is_rehashing = false
	return hash_table
end
function ChainedHashTable:GetHashKey(k)
	return self._hash_args._hash_func(k)
end
function ChainedHashTable:UpdateSize(is_add)
	if is_add then
		self._hash_args._size = self._hash_args._size+1
		if self._hash_args._size/self._hash_args._bucket_count > self._hash_args._max_load_factor then
			local new_bucket_count = self._hash_args._size * 2
			self:Rehash(new_bucket_count)
		end
	else
		self._hash_args._size = self._hash_args._size-1
	end
end
function ChainedHashTable:Set(key, value)
	return self:Find(key, true, value)
end
function ChainedHashTable:Remove(key)
	local node,pre = self:Find(key)
	if node then
		local tmp = node.next
		pre.next = tmp

		self:UpdateSize(false)
		return node
	else
		return nil
	end
end
function ChainedHashTable:Find(key, is_create, value)
	local hash_key = self:GetHashKey(key)
	return self:FindWithHashKey(key, hash_key, is_create, value)
end
function ChainedHashTable:FindWithHashKey(key, hash_key, is_create, value)
	local pre = nil
	local node = self[hash_key]
	while node do
		if node.key == key then
			break
		end
		pre = node
		node = node.next
	end

	if not node and is_create then
		node = Node(key, value)
		if pre then
			pre.next = node
		else
			self[hash_key] = node
		end
		self:UpdateSize(true)
	end

	return node,pre
end
function ChainedHashTable:Rehash(bucket_count)
	if self._hash_args._is_rehashing then
		return
	end

	print(" rehash " .. bucket_count )
	self._hash_args._is_rehashing = true
	local new_hash_func = self._hash_args._hash_func_chooser(bucket_count,self._hash_args._max_key)
	self._hash_args._hash_func = new_hash_func

	local node
	local new_hash_key
	for i=0,self._hash_args._bucket_count-1 do
		node = self[i]
		while node do
			node.mark = false
			node = node.next
		end
	end

	local is_force_pre_node_nil = false
	local pre_node
	local new_node
	for i=0,self._hash_args._bucket_count-1 do
		pre_node = nil
		node = self[i]
		while node do
			is_force_prenode_nil = false
			if not node.mark then
				new_hash_key = new_hash_func(node.key)
				if new_hash_key~=i then
					local new_node = self:FindWithHashKey(node.key, new_hash_key, true, node.value)
					new_node.mark = true
					if pre_node then
						pre_node.next = node.next
					else
						self[i] = node.next
						is_force_pre_node_nil = true
					end
					self:UpdateSize(false)
				else
					node.mark = true
				end
			end
			pre_node = node
			if is_force_pre_node_nil then
				pre_node = nil
			end
			node = node.next
		end
	end

	self._hash_args._bucket_count = bucket_count
	self._hash_args._is_rehashing = false
end
function ChainedHashTable:GenTestData(data_count, is_print, msg)
	for i=1,data_count do
		local key = math.random(0,self._hash_args._max_key)
		self:Set(key,"this is " .. key)
	end
	if is_print then
		self:Print(msg)
	end
end
function ChainedHashTable:Print(msg)
	PrintHashTable(self, msg)
end

------------------------------------------------------------------------------------------------
-- OpenAddrHashTable
local OpenAddrHashTable = {}
function OpenAddrHashTable.__index(tbl, key)
	return OpenAddrHashTable[key]
end
function OpenAddrHashTable.New(hash_func_chooser, probing_func, max_load_factor, bucket_count)
	local hash_table = {}
	setmetatable(hash_table, OpenAddrHashTable)
	hash_table._hash_args = {}
	hash_table._hash_args._size = 0
	hash_table._hash_args._max_load_factor = 1
	hash_table._hash_args._bucket_count = bucket_count
	hash_table._hash_args._hash_func_chooser = hash_func_chooser
	hash_table._hash_args._hash_func = hash_func_chooser(bucket_count)
	hash_table._hash_args._probing_func = probing_func
	hash_table._hash_args._is_rehashing = false
	return hash_table
end

function OpenAddrHashTable:Probing(i, is_find_empty, key)
	return self._hash_args._probing_func(self, self._hash_args._hash_func, i, self._hash_args._bucket_count, key, is_find_empty)
end

function OpenAddrHashTable:UpdateSize(is_add)
	if is_add then
		self._hash_args._size = self._hash_args._size+1
		if self._hash_args._size/self._hash_args._bucket_count > self._hash_args._max_load_factor then
			local new_bucket_count = self._hash_args._size * 2
			self:Rehash(new_bucket_count)
		end
	else
		self._hash_args._size = self._hash_args._size-1
	end
end

function OpenAddrHashTable:Set(key, value)
	local node, hash_key = self:Find(key, true, value)
	return node
end

function OpenAddrHashTable:Remove(key)
	local node, hash_key = self:Find(key, false, value)
	if node then
		self[hash_key] = nil
		self:UpdateSize(false)
		return node
	end
	return nil
end

function OpenAddrHashTable:Find(key, is_create, value)
	local hash_key = self:Probing(0, is_create, key)
	local node
	if hash_key then
		node = self[hash_key]
		if not node and is_create then
			node = Node(key, value)
			self[hash_key] = node
			self:UpdateSize(true)
		end
	else
		if is_create then
			self:Rehash(self._hash_args._size*2)
			return self:Find(key, is_create, value)
		end
	end
	return node, hash_key
end

function OpenAddrHashTable:Rehash(bucket_count)
	print(" rehash " .. bucket_count )
	self._hash_args._bucket_count = bucket_count
end

function OpenAddrHashTable:GenTestData(data_count, is_print, msg)
	local max_key = 10000
	for i=1,data_count do
		local key = math.random(0,max_key)
		self:Set(key,"this is " .. key)
	end
	if is_print then
		self:Print(msg)
	end
end

function OpenAddrHashTable:Print(msg)
	PrintHashTable(self, msg)
end
------------------------------------------------------------------------------------------------
-- Hash Func
function DivideHashChooser(m)
	function DivideHash(k)
		return k%m
	end
	return DivideHash
end

function MultiplyHashChooser(m)
	function MultiplyHash(k)
		-- A = (5^0.5 - 1) / 2
		local A = 0.6180339887
		return math.floor(m*(k*A%1))
	end
	return MultiplyHash
end

function LinearProbing(hash_table, hash_func, i, m, k, is_find_empty)
	local linear_probing = function(hash_func, k, i) return (hash_func(k)+i)%m end
	return DoProbing(linear_probing, hash_table, hash_func, i, m, k, is_find_empty)
end

function QuadraticProbing(hash_table, hash_func, i, m, k, is_find_empty)
	local quadratic_probing = function(hash_func, k, i) return (math.floor(hash_func(k)+0.5*i*i+0.5*i))%m end
	return DoProbing(quadratic_probing, hash_table, hash_func, i, m, k, is_find_empty)
end

function DoubleHashing(hash_table, hash_func, i, m, k, is_find_empty)
	function double_hashing(hash_func, k, i)
		-- not use hash_func
		return k % m + i * k % (m-1)
	end
	return DoProbing(double_hashing, hash_table, hash_func, i, m, k, is_find_empty)
end
function DoProbing(probing_func, hash_table, hash_func, i, m, k, is_find_empty)
	if i==m then
		return nil
	else
		local hash_key = probing_func(hash_func, k, i)

		if is_find_empty then
			if hash_table[hash_key]==nil then
				return hash_key
			else
				return DoProbing(probing_func, hash_table, hash_func, i+1, m, k, is_find_empty)
			end
		else
			if hash_table[hash_key] then
				local node = hash_table[hash_key]
				if node.key==k then
					return hash_key
				end
			end

			return DoProbing(probing_func, hash_table, hash_func, i+1, m, k, is_find_empty)
		end
	end
end

function ConvertBase(num, radix, digit_number)
	local result = {}
	local tmp
	while digit_number>0 do
		tmp = num%radix
		num = (num-tmp)/radix
		table.insert(result,1,tmp)

		digit_number = digit_number - 1
	end
	return result
end

function UniversalHashFuncChooser1(m, max_key)
	local digit_number=1
	while true do
		max_key = max_key/m
		if max_key> 1 then
			digit_number = digit_number+1
		else
			break
		end
	end

	local a = math.random(1, m^digit_number)
	local a_base_m = ConvertBase(a, m, digit_number)
	function UniversalHash(k)
		local k_base_m = ConvertBase(k, m, digit_number)
		local tmp = 0
		for i=1,digit_number do
			tmp = tmp+k_base_m[i]*a_base_m[i]
		end
		return tmp%m
	end
	return UniversalHash
end

function GetPrimeNumber(from_num)
	function IsPrimeNumber(num)
		if num ==0 or num==1 or num==2 then
			return true
		else
			local tmp = math.ceil(num/2)
			while tmp>1 do
				if num%tmp == 0 then
					return false
				end
				tmp = tmp-1
			end
			return true
		end
	end

	while true do
		if IsPrimeNumber(from_num) then
			return from_num
		end
		from_num = from_num + 1
	end
	return -1
end

function UniversalHashFuncChooser2(m, max_key)
	local prime_number = GetPrimeNumber(max_key)
	local a = math.random(1, prime_number-1)
	local b = math.random(0, prime_number)

	function UniversalHash(k)
		return ((a*k+b)%prime_number)%m
	end
	return UniversalHash
end

--local chained_hash_table1 = ChainedHashTable.New(DivideHashChooser, 2, 5, 10000)
--chained_hash_table1:GenTestData(100, true)
local chained_hash_table2 = ChainedHashTable.New(UniversalHashFuncChooser1, 2, 5, 10000)
chained_hash_table2:GenTestData(100, true)
--local chained_hash_table3 = ChainedHashTable.New(UniversalHashFuncChooser2, 2, 5, 10000)
--chained_hash_table3:GenTestData(100, true)
--local openaddr_hash_table1 = OpenAddrHashTable.New(MultiplyHashChooser, LinearProbing, 0.5, 5)
--openaddr_hash_table1:GenTestData(100, true)
--local openaddr_hash_table2 = OpenAddrHashTable.New(MultiplyHashChooser, QuadraticProbing, 0.5, 5)
--openaddr_hash_table2:GenTestData(100, true)
--local openaddr_hash_table3 = OpenAddrHashTable.New(DivideHashChooser, DoubleHashing, 0.5, 5)
--openaddr_hash_table3:GenTestData(100, true)

--PrintArr(ConvertBase(123456, 10, 10))
