%% ����ģ���˻��㷨�е�����ڵ���Ϣ���� %%

function [queue] = SwapCNCID(index, tmp, queue)
% ֻ��Ҫ�����ڵ㵱ǰ�Ĵ���Ļ�����ţ��Լ��ڵ�����
node1 = queue.get(index);
node2 = queue.get(tmp);
temp_node1 = [node1(1), node2(2), node2(3), node1(4), node1(5)];
temp_node2 = [node2(1), node1(2), node1(3), node2(4), node2(5)];

queue.set(index, temp_node1);
queue.set(tmp, temp_node2);

end

