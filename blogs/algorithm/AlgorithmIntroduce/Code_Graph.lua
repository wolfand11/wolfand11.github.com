------------------------------------------------------------------------------------------------
---- @author Dong Guo
---- @email  smile_guodong@163.com
------------------------------------------------------------------------------------------------
local Heap = dofile("D:/Documents/MyProject/Public/wolfand11/source/_posts/algorithm/AlgorithmIntroduce/Code_Heap.lua")

local GraphType = {
    kSparseGraph = 1,
    kDenseGraph = 2
}

local Node = function (v)
    local node = {
        v = v,
        adjList = {},
    }
    return node
end

local SparseGraph = function (isDigraph)
    local graph = {
        type = GraphType.kSparseGraph,
        isDigraph = isDigraph,
        nodes = {}
    }
    return graph
end

local DenseGraph = function (n,isDigraph)
    local graph = {
        type = GraphType.kDenseGraph,
        isDigraph = isDigraph,
        nodeCount = n,
        nodes = {},
        nodesRelation = {}
    }
    for i=1,n do
        graph.nodes = Node()
        graph.nodesRelation[i] = {}
        for j=1,n do
            if not isDigraph and j>i then
                break
            end
            graph.nodesRelation[i][j] = 0
        end
    end
    return graph
end

function GetGraphEdgeSize(g)
    local edgeSize = 0
    if g.type==GraphType.kSparseGraph then
        for i=1,#g.nodes do
            if g.nodes[i].adjList then
                edgeSize = edgeSize + #(g.nodes[i].adjList)
            end
        end
        if not g.isDigraph then
            edgeSize = edgeSize / 2;
        end
    end
    if g.type==GraphType.kDenseGraph then
        for i=1,g.nodeCount do
            for j=1,n do
                if not g.isDigraph and j>i then
                    break
                end
                if g.nodesRelation[i][j] ~= 0 then
                    edgeSize = edgeSize + 1
                end
            end
        end
    end
    return edgeSize;
end

local printCount = 0
function PrintGraph(g)
    if g==nil then
        return
    end

    printCount = printCount + 1
    print("-Graph-Start-------------- " .. printCount)
    local logStr = ""
    if g.type==GraphType.kSparseGraph then
        for i=1,#g.nodes do
            logStr = "" .. g.nodes[i].v
            logStr = logStr .. " : "
            for j=1,#g.nodes[i].adjList do
                logStr = logStr .. g.nodes[i].adjList[j].node.v
                logStr = logStr .. "(".. g.nodes[i].adjList[j].w .. ")"
                logStr = logStr .. ", "
            end
            print(logStr)
        end
    else
        for i=1,#g.nodes do
            print(g.nodes[i].v)
        end
        for i=1,g.nodeCount do
            logStr = ""
            for j=1,g.nodeCount do
				if not g.isDigraph and j>i then
                    break
                end
                logStr = logStr .. g.nodesRelation[i][j] .. "  "
            end
            print(logStr)
        end
    end
    print("-Graph-End  -------------- " .. printCount)
end

function IsExistValue(g, v)
    if g==nil then
        return false
    end

    for i=1,#g.nodes do
        if g.nodes[i].v==v then
            return true
        end
    end
    return false
end

function IsExistNode(g, n)
    if g==nil or n==nil then
        return false
    end

    for i=1,#g.nodes do
        if g.nodes[i]==n then
            return true
        end
    end
    return false
end

------------------------------------------------------------------------------------------------
-- 下列算法将只考虑 稀疏图的情况
------------------------------------------------------------------------------------------------
function InsertNode(g, n, isPError)
    if g==nil or n==nil then
        return
    end

    if IsExistNode(g,n) then
        if isPError then
            print("ERROR node is exist! n.v = " .. tostring(n.v))
        end
        return
    end
    table.insert(g.nodes,n)
end

function IsEdgeExist(g, n1, n2)
    if g==nil or n1==nil or n2==nil then
        return false
    end
    if IsExistNode(n1) and IsExistNode(n2) then
        for i=1,#n1.adjList do
            if n1.adjList[i].node==n2 then
                return true
            end
        end
    end
    return false
end

function InsertEdge(g, n1, n2, weight)
    if g==nil or n1==nil or n2==nil then
        return
    end
    if not IsEdgeExist(g, n1, n2) then
        if weight==nil then
            weight = 1
        end

        InsertNode(g,n1,false)
        InsertNode(g,n2,false)
        local info1 = {
            node = n2,
            w = weight
        }
        table.insert(n1.adjList, info1)

        if not g.isDigraph then
			local info2 = {
				node = n1,
				w = weight
			}
            table.insert(n2.adjList, info2)
        end
    end
end

------------------------------------------------------------------------------------------------
-- Breadth First Search
local NodeColor = {
    kWhite = 1,
    kGray = 2,
    kBlack = 3
}
function PrintGraphNodeInfo(nodeInfoMap,isPNodeInfo)
    if nodeInfoMap and isPNodeInfo then
        for node,nodeInfo in pairs(nodeInfoMap) do
            local logStr = ""
            logStr = logStr .. node.v .. " : color=" .. nodeInfo.color .. " "
            logStr = logStr .. " dis=" .. nodeInfo.distance .. " "
            if nodeInfo.parent then
                logStr = logStr .. " par=" .. nodeInfo.parent.v .. " "
            end
            print(logStr)
        end
    end
end
function BFS(g, s, func, isPNodeInfo)
    if g==nil then
        return
    end
    local queue = {}
    local nodeInfoMap = {}
    for i=1,#g.nodes do
        local node = g.nodes[i]
        nodeInfoMap[node] = {}
        nodeInfoMap[node].color = NodeColor.kWhite
        nodeInfoMap[node].distance = 10000
        nodeInfoMap[node].parent = nil
    end
    nodeInfoMap[s].distance = 0
    table.insert(queue, s)

    local curNode = nil
    local nodeInfo = nil
    local node = nil
    while #queue>0 do
        curNode = table.remove(queue,1)
        nodeInfoMap[curNode].color = NodeColor.kBlack
        if func then
            func(curNode)
        end
        for i=1,#curNode.adjList do
            node = curNode.adjList[i].node
            nodeInfo = nodeInfoMap[node]
            if nodeInfo.color==NodeColor.kWhite then
				nodeInfo.color = NodeColor.kGray
                nodeInfo.distance = nodeInfoMap[curNode].distance + curNode.adjList[i].w
                nodeInfo.parent = curNode

				table.insert(queue,node)
            end
        end

        if #queue==0 then
            for i=1,#g.nodes do
                local node = g.nodes[i]
                if nodeInfoMap[node].color == NodeColor.kWhite then
                    nodeInfoMap[node].distance = 0
                    table.insert(queue,node)
                    break
                end
            end
        end
    end
    PrintGraphNodeInfo(nodeInfoMap,isPNodeInfo)
end
------------------------------------------------------------------------------------------------
-- Depth First Search
function DFS(g, s, func,isPNodeInfo)
    if g==nil then
        return
    end
    local nodeInfoMap = {}
    for i=1,#g.nodes do
        local node = g.nodes[i]
        nodeInfoMap[node] = {}
        nodeInfoMap[node].color = NodeColor.kWhite
        nodeInfoMap[node].distance = 10000
        nodeInfoMap[node].parent = nil
    end
    nodeInfoMap[s].distance = 0

    DFS_Visitor(s, nodeInfoMap, func)
    for i=1,#g.nodes do
        local node = g.nodes[i]
        if nodeInfoMap[node].color==NodeColor.kWhite then
			nodeInfoMap[node].distance = 0
            DFS_Visitor(node, nodeInfoMap, func)
        end
    end

    PrintGraphNodeInfo(nodeInfoMap,isPNodeInfo)
end
function DFS_Visitor(s, nodeInfoMap, func)
    if s then
        local curNode = s
        local nodeInfo = nil
        local node = nil
        nodeInfoMap[curNode].color = NodeColor.kGray

        for i=1,#curNode.adjList do
            node = curNode.adjList[i].node
            nodeInfo = nodeInfoMap[node]
            if nodeInfo.color==NodeColor.kWhite then
                nodeInfoMap[node].parent = curNode
                nodeInfoMap[node].distance = nodeInfoMap[s].distance + curNode.adjList[i].w

                DFS_Visitor(node, nodeInfoMap, func)
            end
        end
        nodeInfoMap[curNode].color = NodeColor.kBlack
        if func then
            func(curNode)
        end
    end
end
function PrintNode(n)
    print(n.v)
end

------------------------------------------------------------------------------------------------
-- Minimum Spanning Trees
function MST_Prim(g,s,isPNodeInfo)
    local nodeInfoMap = {}
    local queue = {}
    for i=1,#g.nodes do
        local node = g.nodes[i]
        table.insert(queue,node)

        nodeInfoMap[node] = {}
        nodeInfoMap[node].color = NodeColor.kWhite
        nodeInfoMap[node].parent = nil
        nodeInfoMap[node].distance = math.huge
    end
    nodeInfoMap[s].distance = 0

    local curNode = nil
    local nodeInfo = nil
    local node = nil
    local weight = math.huge
    while #queue>0 do
        curNode = ExtractMinWeightNode(nodeInfoMap, queue)
        nodeInfoMap[curNode].color = NodeColor.kBlack

        for i=1,#curNode.adjList do
            node = curNode.adjList[i].node
            weight = curNode.adjList[i].w
            --if nodeInfoMap[node].color~=NodeColor.kBlack and nodeInfoMap[node].distance>weight then
            if nodeInfoMap[node].distance>weight then
                nodeInfoMap[node].distance = weight
                nodeInfoMap[node].parent = curNode
            end
        end
    end

    PrintGraphNodeInfo(nodeInfoMap,isPNodeInfo)
end
function ExtractMinWeightNode(nodeInfoMap, queue)
    local node = nil
    local weight = math.huge
    local pos = 1
    for i=1,#queue do
        if nodeInfoMap[queue[i]].distance<=weight then
            node = queue[i]
            weight = nodeInfoMap[node].distance
            pos = i
        end
    end
    if node then
        table.remove(queue, pos)
    end
    return node
end
------------------------------------------------------------------------------------------------
-- Single-Source Shortest Paths
function DijkstraSSSPaths(g, s, isPNodeInfo)
    if g==nil or s==nil then
        return
    end

    local nodeInfoMap = {}
    for i=1,#g.nodes do
        local node = g.nodes[i]
        nodeInfoMap[node] = {}
        nodeInfoMap[node].color = NodeColor.kWhite
        nodeInfoMap[node].parent = nil
        nodeInfoMap[node].distance = math.huge
    end
    nodeInfoMap[s].distance = 0
    local queue = {}
    table.insert(queue,s)

    local curNode = nil
    local curNodeDis= 0
    local nodeInfo = nil
    local node = nil
    while #queue>0 do
        --curNode = table.remove(queue,1)
		curNode = table.remove(queue)
        --curNode = ExtractMinWeightNode(nodeInfoMap, queue)
        nodeInfoMap[curNode].color = NodeColor.kBlack
        curNodeDis = nodeInfoMap[curNode].distance

        for i=1,#curNode.adjList do
            node = curNode.adjList[i].node
            nodeInfo = nodeInfoMap[node]
            if nodeInfo.color==NodeColor.kWhite then
                table.insert(queue,node)
            end
            local newDis = curNode.adjList[i].w + curNodeDis
            if newDis<nodeInfo.distance then
                nodeInfo.distance = newDis
                nodeInfo.parent = curNode
            end
        end

        if #queue==0 then
            for i=1,#g.nodes do
                local node = g.nodes[i]
                if nodeInfoMap[node].color==NodeColor.kWhite then
                    table.insert(queue,node)
                    break
                end
            end
        end
    end

    PrintGraphNodeInfo(nodeInfoMap,isPNodeInfo)
end
------------------------------------------------------------------------------------------------
-- A Star Search Path

------------------------------------------------------------------------------------------------
-- Bellman Ford Shortest Path
function BellmanFordSSSPaths(g, s, isPNodeInfo)
end

------------------------------------------------------------------------------------------------
--
print("-DenseGraph-Start--------")
PrintGraph(DenseGraph(4,true))
local sG = SparseGraph()
local nodes = {}
for i=1,8 do
    nodes[i] = Node(i)
end
InsertEdge(sG, nodes[1], nodes[2], 3)
InsertEdge(sG, nodes[1], nodes[5], 7)
InsertEdge(sG, nodes[2], nodes[3], 4)
InsertEdge(sG, nodes[2], nodes[4], 1)
InsertEdge(sG, nodes[2], nodes[5], 5)
InsertEdge(sG, nodes[3], nodes[4], 2)
InsertEdge(sG, nodes[4], nodes[5], 2)
InsertEdge(sG, nodes[6], nodes[7], 10)
InsertNode(sG, nodes[8])
print("-SparseGraph-Start--------")
PrintGraph(sG)
print("-BFS-Start--------")
BFS(sG,nodes[1],PrintNode,true)
print("-DFS-Start--------")
DFS(sG,nodes[1],PrintNode,true)
print("-MST-Start--------")
MST_Prim(sG,nodes[1],true)
print("-DijkstraSSSPaths-Start--------")
DijkstraSSSPaths(sG,nodes[1],true)
