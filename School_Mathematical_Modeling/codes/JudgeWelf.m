%% ������ḣ��ָ������������ %%
function [Welfrate] = JudgeWelf(oldS, oldS1, allP1, saveS, saveS1, allP2)
%% ��2:3:5�ı����ָ�λ�����������������ܾ����� %%
    Welfrate = 0.2*(oldS1 + saveS1) + 0.3*(oldS + saveS) + 0.5*(allP1 + allP2);

end