%% Э���ռ�����ʽ���ȹ���ָ�ɷ������ս⣬��Ϊģ���˻��Ż��㷨�����ʼ��ĸ������� -- Matlabʵ�� %%

function [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, material_id, new_process_cncID, cnc_type, start_time, continue_time)
% �涨��¼RGVС����ʷ�ƶ�·��rgv_path������Ԫ�����ݽṹservice��Ϊ�����ڵ�洢����
% service -> [i, m, v, ts, tc] -> [RGV������Ĺ������ID��RGV�����CNC������ţ���Ӧ��CNCN�������ͣ�����ִ�еĿ�ʼʱ�䣬������Ҫ������ʱ��]
new_rgv_node = [material_id, new_process_cncID, cnc_type, start_time, continue_time];
rgv_path.addLast(new_rgv_node);

% �涨��¼ÿһ̨CNC�������������cncs_path[8]���������ڵİ˸�Ԫ�طֱ�洢��̨CNC������ʷ����ڵ�
% ͨ���½ڵ�����룬ͬ������service�ṹ��Ϊ�ڵ�洢
target_cnc = cncs_path(new_process_cncID);
new_cnc_service = [material_id, new_process_cncID, cnc_type, start_time, continue_time];
target_cnc.addLast(new_cnc_service);
end

