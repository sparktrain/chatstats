function [chatStats] = generateChatStats(chatFile)
% Chat Statistics Generator
%   This function takes a .txt file of a Pokémon Showdown chat log as
%   input, then generates a list of all unique usernames ranked by number
%   of messages sent to the chat room. The percentage of total messages
%   sent to the chat room and average line length is also shown.

chatLines = 0;
totalLines = 0;
fid = fopen(['logs/' chatFile]);
while feof(fid) == 0
    line = fgetl(fid);
    if length(line) >= 14
        if strcmp(line(10:12), '|c|') && ~strcmp(line(14), '|')
            chatLines = chatLines + 1;
        end
    end
    totalLines = totalLines + 1;
end
fclose(fid);
fprintf('The chat log has been scanned.\n');
fprintf('There are %d chat lines and %d total lines.\n', chatLines, totalLines);

usernames = java_array('java.lang.String', chatLines);
characterCount = zeros(1, chatLines);
currentChatLine = 1;
fid = fopen(['logs/', chatFile]);
while feof(fid) == 0
    line = fgetl(fid);
    if length(line) >= 14
        if strcmp(line(10:12), '|c|') && ~strcmp(line(14), '|')
            verticalBars = strfind(line, '|');
            fullUsername = line((verticalBars(2) + 2):(verticalBars(3) - 1));
            alphanumericUsername = lower(regexprep(fullUsername, '[^a-zA-Z0-9]', ''));
            usernames(currentChatLine) = java.lang.String(alphanumericUsername);
            characterCount(currentChatLine) = length(line) - verticalBars(3);
            currentChatLine = currentChatLine + 1;
        end
    end
end
fclose(fid);
fprintf('The username database has been generated.\n');

uniqueUsernames = java_array('java.lang.String', 1);
messageCount = double.empty(0, chatLines);
uniqueCharacterCount = zeros(1, chatLines);

fprintf('Scanning the username database...\n');
for i = 1:chatLines
    x = 0;
    for j = 1:length(uniqueUsernames)
        if usernames(i) == uniqueUsernames(j)
            messageCount(j) = messageCount(j) + 1;
            uniqueCharacterCount(j) = uniqueCharacterCount(j) + characterCount(i);
            x = x + 1;
        end
    end
    if x == 0
        uniqueUsernames(length(uniqueUsernames)+1) = usernames(i);
        messageCount(length(uniqueUsernames)) = 1;
        uniqueCharacterCount(length(uniqueUsernames)) = uniqueCharacterCount(length(uniqueUsernames)) + characterCount(i);
    end
    if i == chatLines || rem(i, 100) == 0
        fprintf('%d/%d lines scanned\n', i, chatLines);
    end
end

messagePercent = double.empty(0, chatLines);
for i = 1:length(messageCount)
    messagePercent(i) = 100 * (messageCount(i) / chatLines);
end

finalUniqueCharacterCount = [0, uniqueCharacterCount(uniqueCharacterCount ~= 0)];
averageLength = rdivide(finalUniqueCharacterCount, messageCount);

c1 = cell(uniqueUsernames);
c2 = num2cell(transpose(messageCount));
c3 = num2cell(transpose(messagePercent));
c4 = num2cell(transpose(averageLength));
dataArray = [c1 c2 c3 c4];
sortedData = sortrows(dataArray, -2);
sortedData(size(sortedData, 1),:) = [];
rank = cell(size(sortedData, 1), 1);
for i = 1:size(sortedData, 1)
    rank(i) = num2cell(i);
end
header = {'Rank' 'Username' 'Lines' 'Percent Total' 'Average Length'};
chatStats = [header; [rank sortedData]];

end