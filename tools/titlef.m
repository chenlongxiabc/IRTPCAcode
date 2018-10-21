function hh = titlef(str)
% titlef( str )
%
% Display title with FontSize 14. Adds special feature for iteration number
%
if (isnumeric(str))
    str = sprintf('Iteration: %d',str);
end
hh = title(str,'FontSize',14);