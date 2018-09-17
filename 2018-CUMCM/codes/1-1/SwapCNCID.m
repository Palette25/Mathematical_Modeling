%% 用于模拟退火算法中的随机节点信息交换 %%

function [queue] = SwapCNCID(index, tmp, queue)
% 只需要交换节点当前的处理的机器编号，以及节点类型
node1 = queue.get(index);
node2 = queue.get(tmp);
temp_node1 = [node1(1), node2(2), node2(3), node1(4), node1(5)];
temp_node2 = [node2(1), node1(2), node1(3), node2(4), node2(5)];

queue.set(index, temp_node1);
queue.set(tmp, temp_node2);

end

