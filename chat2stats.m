function chat2stats(chatFile)
% Chat Log to Chat Statistics
%   This function takes a .txt file of a Pokémon Showdown chat log as
%   input, runs it through all the statistics generating function, converts
%   the resulting data to .csv files, then saves them in the stats folder.

cell2csv(generateChatStats(chatFile), ['stats/' chatFile(1:length(chatFile)-4) '-chatStats.csv']);
fprintf('Chat Statistics have been successfully generated and saved.\n');
cell2csv(generateUserGroupChatStats(chatFile), ['stats/' chatFile(1:length(chatFile)-4) '-userGroupChatStats.csv']);
fprintf('User Group Chat Statistics have been successfully generated and saved.\n');
cell2csv(generateTourStats(chatFile), ['stats/' chatFile(1:length(chatFile)-4) '-tourStats.csv']);
fprintf('Tournament Statistics have been successfully generated and saved.\n');
cell2csv(generateModStats(chatFile), ['stats/' chatFile(1:length(chatFile)-4) '-modStats.csv']);
fprintf('Moderation Statistics have been successfully generated and saved.\n');
cell2csv(generateQuestionStats(chatFile), ['stats/' chatFile(1:length(chatFile)-4) '-questionStats.csv']);
fprintf('Question Statistics have been successfully generated and saved.\n');

end