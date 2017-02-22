function [userGroupChatStats] = generateUserGroupChatStats(chatFile)
% PS Chat Statistics Generator for User Groups
%   This function takes a .txt file of a Pokemon Showdown chat log as
%   input, then generates a list of PS user groups ranked by number of
%   messages collectively sent to the chat room. The percentage of total 
%   messages sent to the chat room and average line length is also shown.

chatLines = 0;
totalLines = 0;
lines = zeros(8,1);
characterCount = zeros(8,1);
fid = fopen(chatFile);
while feof(fid) == 0
    line = fgetl(fid);
    if length(line) >= 14
        if strcmp(line(10:12), '|c|') && ~ strcmp(line(14), '|')
            chatLines = chatLines + 1;
            verticalBars = strfind(line, '|');
            switch line(13)
                case '+'
                    lines(1) = lines(1) + 1;
                    characterCount(1) = characterCount(1) + length(line) - verticalBars(3);
                case '%'
                    lines(2) = lines(2) + 1;
                    characterCount(2) = characterCount(2) + length(line) - verticalBars(3);
                case '@'
                    lines(3) = lines(3) + 1;
                    characterCount(3) = characterCount(3) + length(line) - verticalBars(3);
                case '*'
                    lines(4) = lines(4) + 1;
                    characterCount(4) = characterCount(4) + length(line) - verticalBars(3);
                case '#'
                    lines(5) = lines(5) + 1;
                    characterCount(5) = characterCount(5) + length(line) - verticalBars(3);
                case '&'
                    lines(6) = lines(6) + 1;
                    characterCount(6) = characterCount(6) + length(line) - verticalBars(3);
                case '~'
                    lines(7) = lines(7) + 1;
                    characterCount(7) = characterCount(7) + length(line) - verticalBars(3);
                otherwise
                    lines(8) = lines(8) + 1;
                    characterCount(8) = characterCount(8) + length(line) - verticalBars(3);
            end
        end
    end
    totalLines = totalLines + 1;
end
fclose(fid);
fprintf('The chat log has been scanned.\n');
fprintf('There are %d chat lines and %d total lines.\n', chatLines, totalLines);

messagePercent = 100 * (lines / chatLines);
averageLength = rdivide(characterCount, lines);

d1 = {'Voices (+)'; 'Drivers (%)'; 'Moderators (@)'; 'Bots (*)'; 'Room Owners (#)'; 'Leaders (&)'; 'Administrators (~)'; 'Regular Users'};
d2 = num2cell(lines);
d3 = num2cell(messagePercent);
d4 = num2cell(averageLength);

dataArray = [d1 d2 d3 d4];

sortedData = sortrows(dataArray, -2);
sortedData = sortedData(all(cell2mat(sortedData(:, 2)) ~= 0, 2), :);

rank = cell(size(sortedData, 1), 1);
for i = 1:size(sortedData, 1)
    rank(i) = num2cell(i);
end

header = {'Rank' 'User Group' 'Lines' '%Total' 'AvgLength'};


userGroupChatStats = [header; [rank sortedData]];

end
