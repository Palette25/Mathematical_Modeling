%% ð������������������������ʽ����ʱ�ĽϽ��������������Ӧ���� %%

function [temp_queue] = BubbleSort(temp_queue, temp_rgv_pos)
for k=0:temp_queue.size()-1
       for t=k+1:temp_queue.size()-1
           ttmp = temp_queue.get(k);
           ttmp1 = temp_queue.get(t);
           ttmp_reldis = abs(temp_rgv_pos - ((ttmp(2) + (mod(ttmp(2), 2)~=0))/2-1));
           ttmp_reldis1 = abs(temp_rgv_pos - ((ttmp1(2) + (mod(ttmp1(2), 2)~=0))/2-1));
           if ttmp_reldis > ttmp_reldis1
              temp_queue.set(k ,ttmp1);
              temp_queue.set(t, ttmp);
           end
       end
    end

end

