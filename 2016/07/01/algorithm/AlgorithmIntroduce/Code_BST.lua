------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
---- BST BinarySearchTree
------------------------------------------------------------------------------------------------
function PrintNode(node)
	if node then
		local msg = ""
		msg = msg .. "v=" .. tostring(node.value) .. "   "
		if node.parent then
			msg = msg .. "p=" .. tostring(node.parent.value) .. " "
		end
		if node.left then
			msg = msg .. "l=" .. tostring(node.left.value) .. " "
		end
		if node.right then
			msg = msg .. "r=" .. tostring(node.right.value) .. " "
		end
		print(msg)
	else
		print("node is nil!")
	end
end

------------------------------------------------------------------------------------------------
-- Node
function Node (value, parent)
	local node = {}
	node.value = value
	node.parent = parent
	node.left = nil
	node.right = nil
	return node
end

------------------------------------------------------------------------------------------------
-- BST BinarySearchTree
function BST_Create(arr)
	local tree
	for i=1,#arr do
		tree = BST_Insert(tree, arr[i])
	end
	return tree
end

function BST_Insert(tree, value)
	local node = Node(value)
	local tmp = tree
	if tmp then
		while tmp do
			if tmp.value < value then
				if tmp.right then
					tmp = tmp.right
				else
					tmp.right = node
					node.parent = tmp
					break
				end
			else
				if tmp.left then
					tmp = tmp.left
				else
					tmp.left = node
					node.parent = tmp
					break
				end
			end
		end
	else
		tree = node
	end
	return tree
end

function BST_Delete(node)
	if node then
		local parent = node.parent
		local replace_node
		if node.left and node.right then
			replace_node = BST_Max(node.left)
			BST_Delete(replace_node)
			replace_node.left = node.left
			replace_node.right = node.right
			
			if node.left then
				node.left.parent = replace_node
			end
			node.right.parent = replace_node
		else
			if node.left then
				replace_node = node.left
			elseif node.right then
				replace_node = node.right
			else
				replace_node = nil
			end
		end
		if replace_node then
			replace_node.parent = parent
		end
		if parent then
			if parent.left == node then
				parent.left = replace_node
			else
				parent.right = replace_node
			end
		else
			node.is_empty_tree = true
		end
	end
end

function PreorderWalk(tree, visitor)
	if tree then
		visitor(tree)
		if tree.left then
			PreorderWalk(tree.left, visitor)
		end
		if tree.right then
			PreorderWalk(tree.right, visitor)
		end
	end
end

function PreorderWalkEx(tree, visitor)
	local tmp
	local stack = {tree}
	while #stack>0 do
		tmp = table.remove(stack, #stack)
		if tmp then
			visitor(tmp)
			if tmp.right then
				table.insert(stack, tmp.right)
			end
			if tmp.left then
				table.insert(stack, tmp.left)
			end
		end
	end
end

function InorderWalk(tree, visitor)
	if tree then
		if tree.left then
			InorderWalk(tree.left, visitor)
		end
		visitor(tree)
		if tree.right then
			InorderWalk(tree.right, visitor)
		end
	end
end

function InorderWalkEx(tree, visitor)
	local tmp
	local stack = {tree}
	local visit_record = {}
	while #stack>0 do
		tmp = stack[#stack]
		if tmp.left and not visit_record[tmp.left] then
			table.insert(stack, tmp.left)
		else
			table.remove(stack, #stack)
			visitor(tmp)
			visit_record[tmp] = true
			if tmp.right and not visit_record[tmp.right] then
				table.insert(stack, tmp.right)
			end
		end
	end
end

function PostorderWalk(tree, visitor)
	if tree then
		if tree.left then
			PostorderWalk(tree.left, visitor)
		end
		if tree.right then
			PostorderWalk(tree.right, visitor)
		end
		visitor(tree)
	end
end

function PostorderWalkEx(tree, visitor)
	local tmp
	local stack = {tree}
	local visit_record = {}
	while #stack>0 do
		tmp = stack[#stack]
		if tmp then
			if tmp.left and not visit_record[tmp.left] then
				table.insert(stack, tmp.left)
			elseif tmp.right and not visit_record[tmp.right] then
				table.insert(stack, tmp.right)
			else
				visitor(tmp)
				visit_record[tmp] = true
				table.remove(stack,#stack)
			end
		end
	end
end

function BST_Search(tree, value)
	local tmp = tree
	if tmp then
		if tmp.value == value then
			return tmp
		elseif tmp.value < value then
			return BST_Search(tmp.right, value)
		else
			return BST_Search(tmp.left, value)
		end
	end
	return nil
end

function BST_SearchEx(tree, value)
	local tmp = tree
	while tmp do
		if tmp.value == value then
			return tmp
		elseif tmp.value < value then
			tmp = tmp.right
		else
			tmp = tmp.left
		end
	end
	return nil
end

function BST_Min(tree)
	local tmp = tree
	while tmp do
		if tmp.left then
			tmp = tmp.left
		else
			return tmp
		end
	end
	return nil
end

function BST_Max(tree)
	local tmp = tree
	while tmp do
		if tmp.right then
			tmp = tmp.right
		else
			return tmp
		end
	end
end

function BST_Precursor(node)
	if node.left then
		return BST_Max(node.left)
	else
		local parent = node.parent
		local tmp = node
		while parent and parent.left==tmp do
			tmp = parent
			parent = parent.parent
		end
		return parent
	end
end

function BST_Successor(node)
	if node.right then
		return BST_Min(node.right)
	else
		local parent = node.parent
		local tmp = node
		while parent and parent.right==tmp do
			tmp = parent
			parent = tmp.parent
		end
		return parent
	end
end

local tree = BST_Create({2,9,4,3,1,10,30})
local tmpNode
--print("------------- PreorderWalk")
--PreorderWalk(tree, PrintNode)
--print("------------- PreorderWalkEx")
--PreorderWalkEx(tree, PrintNode)
--print("------------- InorderWalk")
--InorderWalk(tree, PrintNode)
--print("------------- InorderWalk_V2")
--InorderWalkEx(tree, PrintNode)
--print("------------- PostorderWalk")
--PostorderWalk(tree, PrintNode)
--print("------------- PostorderWalkEx")
--PostorderWalkEx(tree, PrintNode)
--print("------------- BST_Search")
--PrintNode(BST_Search(tree, 9))
--PrintNode(BST_SearchEx(tree, 9))
--print("------------- BST_Min&Max")
--PrintNode(BST_Min(tree))
--PrintNode(BST_Max(tree))
print("------------- Precursor&Successor")
tmpNode = BST_Search(tree, 3)
PrintNode(BST_Precursor(tmpNode))
PrintNode(BST_Successor(tmpNode))
--print("------------- BST_Delete")
--tmpNode = BST_Search(tree, 9)
--BST_Delete(tmpNode)
--PreorderWalk(tree, PrintNode)
