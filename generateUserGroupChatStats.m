function [userGroupChatStats] = generateUserGroupChatStats(chatFile)
% User Group Chat Statistics Generator
%   This function takes a .txt file of a Pokémon Showdown chat log as
%   input, then generates a list of PS user groups ranked by number of
%   messages collectively sent to the chat room. The percentage of total
%   messages sent to the chat room and average line length is also shown.

chatLines = 0;
totalLines = 0;
lines = zeros(8,1);
characterCount = zeros(8,1);
fid = fopen(['logs/' chatFile]);
while feof(fid) == 0
    line = fgetl(fid);
    if length(line) >= 14
        if strcmp(line(10:12), '|c|') && ~strcmp(line(14), '|')
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

c1 = {'Voices'; 'Drivers'; 'Moderators'; 'Bots'; 'Room Owners'; 'Leaders'; 'Administrators'; 'Regular Users'};
c2 = num2cell(lines);
c3 = num2cell(messagePercent);
c4 = num2cell(averageLength);
c5 = cellfun(@(x,y) x.*y, c2, c4, 'UniformOutput', false); % Total Character Count
dataArray = [c1 c2 c3 c4 c5];

sortedWeightedData = sortrows(dataArray, -5);
sortedWeightedData = sortedWeightedData(all(cell2mat(sortedWeightedData(:, 2)) ~= 0, 5),:);
weightedRank = cell(size(sortedWeightedData, 1), 1);
for i = 1:size(sortedWeightedData, 1)
    weightedRank(i) = num2cell(i);
end
sortedWeightedData = [sortedWeightedData(:, 1:4) weightedRank];

sortedData = sortrows(sortedWeightedData, -2);
rank = cell(size(sortedData, 1), 1);
for i = 1:size(sortedData, 1)
    rank(i) = num2cell(i);
end

header = {'Rank' 'User Group' 'Lines' 'Percent Total' 'Average Length' 'Weighted Rank'};
userGroupChatStats = [header; [rank sortedData]];

end