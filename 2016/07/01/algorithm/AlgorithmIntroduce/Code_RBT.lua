------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
---- Red Black Tree
------------------------------------------------------------------------------------------------
function PrintNode(node)
	if node then
		local msg = ""
		msg = msg .. "v=" .. tostring(node.value) .. " "
		msg = msg .. "c=" .. node.color .. " "
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
local Color = {
	red = "red",
	black = "black"
}

function Node (value, color, parent)
	local node = {}
	node.value = value
	node.color = color
	node.parent = parent
	node.left = nil
	node.right = nil
	return node
end

------------------------------------------------------------------------------------------------
-- Red Black Tree
function RBT_Create(arr)
	local tree
	for i=1,#arr do
		tree = RBT_Insert(tree, arr[i])
	end
	return tree
end

function RBT_Insert(tree, value)
	local node = Node(value, Color.red)
	if not tree then
		node.color = Color.black
		return node, node
	else
		local tmp = tree
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
	end
	tree = RBT_InsertFixup(tree, node)
	return tree,node
end

function RBT_InsertFixup(tree, node)
	local grand_parent
	local uncle
	local is_parent_left
	local is_self_left
	while node.color==Color.red and node.parent and node.parent.color == Color.red do
		grand_parent = node.parent.parent
		if grand_parent.left == node.parent then
			is_parent_left = true
			uncle = grand_parent.right
		else
			is_parent_left = false
			uncle = grand_parent.left
		end
		if uncle and uncle.color == Color.red then
			grand_parent.color = Color.red
			node.parent.color = Color.black
			uncle.color = Color.black

			node = grand_parent
		else
			if node == node.parent.left then
				is_self_left = true
			else
				is_self_left = false
			end
			if is_self_left~=is_parent_left then
				BST_Rotate(node.parent, is_self_left)
			end
			BST_Rotate(grand_parent, is_parent_left)
			grand_parent.parent.color = Color.black
			grand_parent.color = Color.red

			node = grand_parent.parent
		end
	end

	if not node.parent then
		tree = node
	end
	tree.color = Color.black
	return tree
end

function BST_Rotate(node, is_right)
	local child
	local grandson
	local is_self_left
	if node.parent and node.parent.left==node then
		is_self_left = true
	end
	if is_right then
		child = node.left
		if child then
			grandson = child.right

			if node.parent then
				if is_self_left then
					node.parent.left = child
				else
					node.parent.right = child
				end
			end
			child.parent = node.parent
			child.right = node
			node.parent = child
			node.left = grandson
			if grandson then
				grandson.parent = node
			end
		end
	else
		child = node.right
		if child then
			grandson = child.left

			if node.parent then
				if is_self_left then
					node.parent.left = child
				else
					node.parent.right = child
				end
			end
			child.parent = node.parent
			child.left = node
			node.parent = child
			node.right = grandson
			if grandson then
				grandson.parent = node
			end
		end
	end
end

function RBT_Delete(tree, node)
	local replacer_node
	local need_rm_node = node
	if not node.left then
		replacer_node = node.right
	elseif not node.right then
		replacer_node = node.left
	else
		need_rm_node = BST_Predecessor(node)
		replacer_node = need_rm_node.left
	end

	if need_rm_node.parent then
		if need_rm_node.parent.left == need_rm_node then
			need_rm_node.parent.left = replacer_node
		else
			need_rm_node.parent.right = replacer_node
		end
	end
	if replacer_node then
		replacer_node.parent = need_rm_node.parent
	end

	if need_rm_node~=node then
		node.value = need_rm_node.value
	end
	if tree == need_rm_node then
		tree = replacer_node
	end
	if need_rm_node.color == Color.black then
		tree = RBT_DeleteFixup(tree, need_rm_node)
	end
	return tree
end

function RBT_DeleteFixup(tree, node)
	local fixed_node = node
	local brother
	local is_self_left
	local left_niece
	local right_niece
	local case
	while fixed_node do
		if fixed_node.color == Color.red then
			fixed_node.color = Color.black
			break
		end
		is_self_left = false
		if fixed_node.parent.left == fixed_node then
			is_self_left = true
		end
		if is_self_left then
			brother = fixed_node.parent.right
		else
			brother = fixed_node.parent.left
		end
		if brother.color == Color.red then
			case = 1
		else
			left_niece = brother.left
			right_niece = brother.right
			if right_niece and right_niece.color==Color.red then
				if is_self_left then
					case = 4
				else
					if left_niece and left_niece==Color.red then
						case = 4
					else
						case = 3
					end
				end
			elseif left_niece and left_niece==Color.red then
				if is_self_left then
					case = 3
				else
					case = 4
				end
			else
				case = 2

			end
		end
		if case == 1 then
			BST_Rotate(fixed_node.parent, is_self_left)
			fixed_node.parent.color = Color.red
			brother.color = Color.black
		elseif case == 2 then
			brother.color = Color.black
			fixed_node = fixed_node.parent
		elseif case == 3 then
			BST_Rotate(brother, is_self_left)
			brother.parent.color = Color.black
			brother.color = Color.red
			fixed_node = brother
		elseif case == 4 then
			BST_Rotate(fixed_node.parent, not is_self_left)
			fixed_node.parent.color = Color.black
			brother.color = Color.red
			if is_self_left then
				right_niece.color = Color.black
			else
				left_niece.color = Color.black
			end
			if not brother.parent then
				tree = brother
			end
			break
		else
			print("error case = " .. tostring(case))
		end
	end
	return tree
end

function InorderWalkEx(tree, visitor)
	local tmp
	local stack = {tree}
	local visit_marker = {}
	while #stack>0 do
		tmp = stack[#stack]
		if tmp.left and not visit_marker[tmp.left] then
			table.insert(stack, tmp.left)
		else
			visit_marker[tmp] = true
			visitor(tmp)
			table.remove(stack,#stack)
			if tmp.right and not visit_marker[tmp.right] then
				table.insert(stack, tmp.right)
			end
		end
	end
end

function BST_SearchEx(tree, value)
	while tree do
		if tree.value==value then
			return tree
		elseif tree.value<value then
			tree = tree.right
		else
			tree = tree.left
		end
	end
	return nil
end

function BST_Min(tree)
	while tree do
		if tree.left then
			tree = tree.left
		else
			return tree
		end
	end
	return nil
end

function BST_Max(tree)
	while tree do
		if tree.right then
			tree = tree.right
		else
			return tree
		end
	end
	return nil
end

function BST_Predecessor(node)
	if node.left then
		return BST_Max(node.left)
	else
		while node.parent and node.parent.left==node do
			node = node.parent
		end
		return node.parent
	end
end

function BST_Successor(node)
	if node.right then
		return BST_Min(node.right)
	else
		while node.parent and node.parent.right ==node do
			node = node.parent
		end
		return node.parent
	end
end

local tree = RBT_Create({2,9,4,3,1,10,30})
local tmpNode
print("------------- InorderWalkEx")
InorderWalkEx(tree, PrintNode)
print("------------- BST_Delete")
tmpNode = BST_SearchEx(tree, 10)
tree = RBT_Delete(tree, tmpNode)
InorderWalkEx(tree, PrintNode)
