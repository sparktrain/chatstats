function [modStats] = generateModStats(chatFile)
% Moderation Statistics Generator
%   This function takes a .txt file of a Pok�mon Showdown chat log as
%   input, then generates a list of usernames ranked by number of
%   moderative actions taken in the chat room.

modLines = 0;
totalLines = 0;
fid = fopen(['logs/' chatFile]);
while feof(fid) == 0
    line = fgetl(fid);
    verticalBars = strfind(line, '|');
    if length(verticalBars) >= 3
        if length(line) >= verticalBars(3) + 4
            if strcmp(line((verticalBars(3) + 1):(verticalBars(3) + 4)), '/log')
                modLines = modLines + 1;
            end
        end
    end
    totalLines = totalLines + 1;
end
fclose(fid);
fprintf('The chat log has been scanned.\n');
fprintf('There are %d lines containing moderative actions and %d total lines.\n', modLines, totalLines);

if modLines > 0
    usernames = java_array('java.lang.String', modLines);
    currentChatLine = 1;
    fid = fopen(['logs/' chatFile]);
    while feof(fid) == 0
        line = fgetl(fid);
        verticalBars = strfind(line, '|');
        if length(verticalBars) >= 3
            if length(line) >= verticalBars(3) + 4
                if strcmp(line((verticalBars(3) + 1):(verticalBars(3) + 4)), '/log')
                    fullUsername = line((verticalBars(2) + 2):(verticalBars(3) - 1));
                    alphanumericUsername = lower(regexprep(fullUsername, '[^a-zA-Z0-9]', ''));
                    usernames(currentChatLine) = java.lang.String(alphanumericUsername);
                    currentChatLine = currentChatLine + 1;
                end
            end
        end
    end
    fclose(fid);
    fprintf('The username database has been generated.\n');

    uniqueUsernames = java_array('java.lang.String', 1);
    modCount = double.empty(0, modLines);

    fprintf('Scanning the username database...\n');
    reverse = '';
    for i = 1:modLines
        for j = 1:length(uniqueUsernames)
            if usernames(i) == uniqueUsernames(j)
                modCount(j) = modCount(j) + 1;
                unique = false;
                break
            else
                unique = true;
            end
        end
        if unique
            uniqueUsernames(length(uniqueUsernames)+1) = usernames(i);
            modCount(length(uniqueUsernames)) = 1;
        end
        progress = sprintf('%d/%d lines scanned\n', i, modLines);
        fprintf([reverse, progress]);
        reverse = repmat(sprintf('\b'), 1, length(progress));
    end

    modPercent = double.empty(0, modLines);
    for i = 1:length(modCount)
        modPercent(i) = 100 * (modCount(i) / modLines);
    end

    c1 = cell(uniqueUsernames);
    c2 = num2cell(transpose(modCount));
    c3 = num2cell(transpose(modPercent));
    dataArray = [c1 c2 c3];
    sortedData = sortrows(dataArray, -2);
    sortedData(size(sortedData, 1),:) = [];
    rank = cell(size(sortedData, 1), 1);
    for i = 1:size(sortedData, 1)
        rank(i) = num2cell(i);
    end
    header = {'Rank' 'Username' 'Mod Actions' 'Percent Total'};
    modStats = [header; [rank sortedData]];
else
    fprintf('There were no moderative actions taken during this period.\n');
    modStats = {'Rank' 'Username' 'Mod Actions' 'Percent Total'};
end

end