function [small,big]=split(data,splitno)
small = data(1:splitno,:);
big = data(1+splitno:end,:);
end
