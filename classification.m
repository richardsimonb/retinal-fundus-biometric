clear all;
close all;
clc;

load D:\Thesis\BiometricProgram\data.mat;

inputs = feat;
targets = target;


hiddenLayerSize = 40;
performFcn = 'sse';
trainFcn = 'traingdm';

goalError = 0.1;
epochs = 10000;
momentumRate = 0.625;
learningRate = 0.0001;

net = feedforwardnet(hiddenLayerSize,trainFcn);

net.trainParam.epochs = epochs;
net.trainParam.goal = goalError;
net.trainParam.mc = momentumRate;
net.trainParam.lr = learningRate;

%net.trainParam.max_fail = 100;

net.divideFcn = 'dividetrain';

% net = patternnet(hiddenLayerSize);
% net.divideParam.trainRatio = 80/100;
% net.divideParam.valRatio = 10/100;
% net.divideParam.testRatio = 10/100;
 
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);

%plotconfusion(target,outputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);
%view(net)

[c,cm,ind,per] = confusion(target,outputs);
fprintf('Training Percentage Correct Classification   : %f%%\n', 100*(1-c));
fprintf('Training Percentage Incorrect Classification : %f%%\n', 100*c);

[tpr,fpr,thresholds] = roc(targets,outputs);