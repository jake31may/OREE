function [output1,output2]= sortit(input1,input2)

[output1,Index] = sort(input1);

output2 = input2(Index,:);
end