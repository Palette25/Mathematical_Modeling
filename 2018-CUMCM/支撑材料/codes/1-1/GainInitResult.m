%% 协助收集启发式优先规则指派方法最终解，作为模拟退火优化算法输入初始解的辅助函数 -- Matlab实现 %%

function [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, material_id, new_process_cncID, cnc_type, start_time, continue_time)
% 规定记录RGV小车历史移动路径rgv_path，以五元素数据结构service作为基本节点存储其中
% service -> [i, m, v, ts, tc] -> [RGV所处理的工件编号ID，RGV处理的CNC机器编号，对应的CNCN机器类型，任务执行的开始时间，任务需要持续的时间]
new_rgv_node = [material_id, new_process_cncID, cnc_type, start_time, continue_time];
rgv_path.addLast(new_rgv_node);

% 规定记录每一台CNC所处理过的任务cncs_path[8]，该数组内的八个元素分别存储八台CNC机器历史处理节点
% 通过新节点的引入，同样采用service结构作为节点存储
target_cnc = cncs_path(new_process_cncID);
new_cnc_service = [material_id, new_process_cncID, cnc_type, start_time, continue_time];
target_cnc.addLast(new_cnc_service);
end

