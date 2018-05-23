%% 评价社会福利指数的评估函数 %%
function [Welfrate] = JudgeWelf(oldS, oldS1, allP1, saveS, saveS1, allP2)
%% 以2:3:5的比例分割位置数，机构数，和总救助数 %%
    Welfrate = 0.2*(oldS1 + saveS1) + 0.3*(oldS + saveS) + 0.5*(allP1 + allP2);

end