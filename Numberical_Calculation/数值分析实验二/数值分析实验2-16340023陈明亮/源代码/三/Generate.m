%% 随机生成10000X10的，元素服从独立同分布的正态分布的矩阵A，以及维度为10000的向量b %%
function [A, b] = Generate()
A = randn(10000, 10);
b = randn(10000, 1);
end