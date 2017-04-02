------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
------------------------------------------------------------------------------------------------
-- Red Black Tree implement
-- 在BST_example中所有实现采用的递归方式，所以在此处将不用递归方式来实现Red Black Tree

local Node = function (v)
    local node = {
        p = nil,
        l = nil,
        r = nil,
        v = v,
		color = nil
    }
    return node
end

function PrintNodeInfo(node)
    if node then
        print(tostring(node.v)  .. " " .. tostring(node.color))
	else
		print("node is nil")
	end
end

-- Traverse 遍历
function RBT_InorderTraverse(rbt)
	local stack = {}
	while rbt~=nil or #stack>0 do
		while rbt do
			table.insert(stack, rbt)
			rbt = rbt.l
		end
		rbt = table.remove(stack,#stack)
		PrintNodeInfo(rbt)
		rbt = rbt.r
	end
end

-- Find 查找
function RBT_Find(rbt, value)
	while rbt~=nil do
		if rbt.v == value then
			return rbt
		elseif rbt.v < value then
			rbt = rbt.r
		else
			rbt = rbt.l
		end
	end
	return nil
end

function RBT_MaxNode(rbt, parent)
    while rbt do
		if rbt.r then
			rbt = rbt.r
		else
			return rbt
		end
	end
end

function RBT_MinNode(rbt, parent)
    while rbt do
		if rbt.l then
			rbt = rbt.l
		else
			return rbt
		end
	end
end

function RBT_Precessor(node)
    if node.l~=nil then
        return RBT_MaxNode(node.l)
    else
        while node.p~=nil do
            if node.p.r==node then
                return node.p
            else
                node = node.p
            end
        end
    end
end

function RBT_Successor(node)
    if node.r~=nil then
        return RBT_MinNode(node.r)
    else
        while node.p~=nil do
            if node.p.l == node then
                return node.p
            else
                node = node.p
            end
        end
    end
end

-- Insert
function RBT_Insert(rbt, node)
	
end

function BST_Insert(bst, node, parent, isLeft)
    if node==nil or node.v==nil then
        return
    end
  
    if bst==nil or bst.v == nil then
        bst = node
        node.p = parent
        if parent then
            if isLeft then
                parent.l = node
            else
                parent.r = node
            end
        end
    else
        if node.v<bst.v then
            BST_Insert(bst.l, node, bst, true);
        else
            BST_Insert(bst.r, node, bst, false);
        end
    end
    return bst;
end

-- Delete
function RBT_Delete(bst,node)
	
end

local RBT = BST_Insert(nil, Node(10));
print(RBT);
BST_Insert(RBT, Node(3));
BST_Insert(RBT, Node(20));
BST_Insert(RBT, Node(1));
BST_Insert(RBT, Node(8));
BST_Insert(RBT, Node(7));
RBT_InorderTraverse(RBT);
print("--- find 8")
PrintNodeInfo(RBT_Find(RBT,8))
print("--- max")
PrintNodeInfo(RBT_MaxNode(RBT))
print("--- min")
PrintNodeInfo(RBT_MinNode(RBT))