function cell2csv(cellArray, fileName)
% Cell Array to Comma-Separated Values File
%   This function takes a cell array as input (cellArray) and saves it as a
%   .csv file at fileName.

cellArray = cellfun(@strX, cellArray, 'UniformOutput', false);
[rows, cols] = size(cellArray);
fid = fopen(fileName, 'w');
for row = 1:rows
    fprintf(fid, [sprintf('%s,', cellArray{row, 1:cols-1}), cellArray{row, cols}, '\n']);
end
fclose(fid);

    function x = strX(x)
        if (isnumeric(x) && isrow(x)) || (isrow(x) && ~iscell(x))
            x = num2str(x);
        elseif isempty(x)
            x = '';
        end
    end

end