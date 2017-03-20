function chat2stats(chatFile)
% Chat Log to Chat Statistics
%   This function takes a .txt file of a Pok�mon Showdown chat log as
%   input, runs it through the specified statistics generating functions,
%   then converts the resulting cell arrays to .csv files which are stored
%   in the stats folder.

% Toggle these to generate specific statistics
chatStats = true;
userGroupChatStats = false;
tourStats = true;
modStats = false;
questionStats = false;

directory = 'stats/'; % Default directory is the stats folder
logName = chatFile(1:length(chatFile)-4);

if chatStats
    cell2csv(generateChatStats(chatFile), [directory logName '-chatStats.csv']);
    fprintf('Chat Statistics have been successfully generated and saved.\n');
end

if userGroupChatStats
    cell2csv(generateUserGroupChatStats(chatFile), [directory logName '-userGroupChatStats.csv']);
    fprintf('User Group Chat Statistics have been successfully generated and saved.\n');
end

if tourStats
    cell2csv(generateTourStats(chatFile), [directory logName '-tourStats.csv']);
    fprintf('Tournament Statistics have been successfully generated and saved.\n');
end

if modStats
    cell2csv(generateModStats(chatFile), [directory logName '-modStats.csv']);
    fprintf('Moderation Statistics have been successfully generated and saved.\n');
end

if questionStats
    cell2csv(generateQuestionStats(chatFile), [directory logName '-questionStats.csv']);
    fprintf('Question Statistics have been successfully generated and saved.\n');
end

end