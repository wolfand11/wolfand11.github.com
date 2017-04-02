------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
------------------------------------------------------------------------------------------------
-- Binary Search Tree implement

local Node = function (v)
    local node = {
        p = nil,
        l = nil,
        r = nil,
        v = v
    }
    return node
end

-- Binary Search Tree
function PrintNodeValue(node)
    if node then
        print(node.v)
    end
end

-- Traverse 遍历
function BST_PreorderTraverse(bst)
    if bst==nil or bst.v==nil then
        return
    end
    PrintNodeValue(bst)
    BST_PreorderTraverse(bst.l)
    BST_PreorderTraverse(bst.r)
end

function BST_InorderTraverse(bst)
    if bst==nil or bst.v==nil then
        return
    end
    BST_InorderTraverse(bst.l)
    PrintNodeValue(bst)
    BST_InorderTraverse(bst.r)
end

function BST_PostorderTraverse(bst)
    if bst==nil or bst.v==nil then
        return
    end
    BST_PostorderTraverse(bst.l)
    BST_PostorderTraverse(bst.r)
    PrintNodeValue(bst)
end

-- Find 查找
function BST_Find(bst, value)
    if bst==nil or bst.v==nil then
        return nil
    end
  
    if bas.v == value then
        return bas
    elseif bas.v < value then
        return BST_Find(bst.r, value)
    else
        return BST_Find(bst.l, value)
    end
end

function BST_MaxNode(bst, parent)
    if bst==nil then
        return parent
    end
    return BST_MaxNode(bst.r, bst);
end

function BST_MinNode(bst, parent)
    if bst==nil then
        return parent
    end
    return BST_MinNode(bst.l, bst)
end

function BST_Precessor(node)
    if node.l~=nil then
        return BST_MaxNode(node.l)
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

function BST_Successor(node)
    if node.r~=nil then
        return BST_MinNode(node.r)
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
function BST_Delete(bst,node)
    if node~=nil then
        local newNode = nil
        if node.l==nil then
            if node==node.p.l then
                node.p.l = node.r
            else
                node.p.r = node.r
            end
            newNode = node.r
        elseif node.r==nil then
            if node==node.p.l then
                node.p.l = node.l
            else
                node.p.r = node.l
            end
            newNode = node.l
        else
            successor = BST_Successor(node)
            BST_Delete(bst,successor)
            successor.p = node.p
            successor.l = node.l
            successor.r = node.r
            newNode = successor
        end
      
        if node==bst then
            bst.p = newNode.p
            bst.l = newNode.l
            bst.r = newNode.r
            bst.v = newNode.v
        end
    end
end


--- TEST
PrintNodeValue(Node(20));
local BST = BST_Insert(nil, Node(10));
print(BST);
BST_Insert(BST, Node(3));
BST_Insert(BST, Node(20));
BST_Insert(BST, Node(1));
BST_Insert(BST, Node(8));
BST_Insert(BST, Node(7));
BST_InorderTraverse(BST);
print("Max = " .. BST_MaxNode(BST,nil).v);
print("Min = " .. BST_MinNode(BST,nil).v);

local xNode = Node(5);
BST_Insert(BST, xNode);
local xPrecessorV = BST_Precessor(xNode)
if xPrecessorV then 
    xPrecessorV = xPrecessorV.v
end
local xSuccessorV = BST_Successor(xNode)
if xSuccessorV then
    xSuccessorV = xSuccessorV.v
end
BST_InorderTraverse(BST);
print("5 Precessor = " .. tostring(xPrecessorV))
print("5 Successor = " .. tostring(xSuccessorV))

print("root node = " .. BST.v)
BST_Delete(BST,BST)
BST_InorderTraverse(BST);

BST_Delete(BST,xNode)
BST_InorderTraverse(BST);
