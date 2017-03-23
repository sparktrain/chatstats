function [questionStats] = generateQuestionStats(chatFile)
% Question Statistics Generator
%   This function takes a .txt file of a Pokémon Showdown chat log as
%   input, then generates a list of usernames ranked by number of lines
%   sent to the chat room which contained at least one question mark.

questionLines = 0;
totalLines = 0;
fid = fopen(['logs/' chatFile]);
while feof(fid) == 0
    line = fgetl(fid);
    verticalBars = strfind(line, '|');
    if length(verticalBars) >= 3
        if strcmp(line(10:12), '|c|') && ~strcmp(line(14), '|') && length(line) >= verticalBars(3) + 1
            message = line((verticalBars(3) + 1):length(line));
            questionMarks = strfind(message, '?');
            if length(questionMarks) >= 1
                questionLines = questionLines + 1;
            end
        end
    end
    totalLines = totalLines + 1;
end
fclose(fid);
fprintf('The chat log has been scanned.\n');
fprintf('There are %d lines with question marks and %d total lines.\n', questionLines, totalLines);

if questionLines > 0
    usernames = java_array('java.lang.String', questionLines);
    currentChatLine = 1;
    fid = fopen(['logs/' chatFile]);
    while feof(fid) == 0
        line = fgetl(fid);
        verticalBars = strfind(line, '|');
        if length(verticalBars) >= 3
            if strcmp(line(10:12), '|c|') && ~strcmp(line(14), '|') && length(line) >= verticalBars(3) + 1
                message = line((verticalBars(3) + 1):length(line));
                questionMarks = strfind(message, '?');
                if length(questionMarks) >= 1
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
    questionCount = double.empty(0, questionLines);

    fprintf('Scanning the username database...\n');
    reverse = '';
    for i = 1:questionLines
        for j = 1:length(uniqueUsernames)
            if usernames(i) == uniqueUsernames(j)
                questionCount(j) = questionCount(j) + 1;
                unique = false;
                break
            else
                unique = true;
            end
        end
        if unique
            uniqueUsernames(length(uniqueUsernames)+1) = usernames(i);
            questionCount(length(uniqueUsernames)) = 1;
        end
        progress = sprintf('%d/%d lines scanned\n', i, questionLines);
        fprintf([reverse, progress]);
        reverse = repmat(sprintf('\b'), 1, length(progress));
    end

    questionPercent = double.empty(0, questionLines);
    for i = 1:length(questionCount)
        questionPercent(i) = 100 * (questionCount(i) / questionLines);
    end

    c1 = cell(uniqueUsernames);
    c2 = num2cell(transpose(questionCount));
    c3 = num2cell(transpose(questionPercent));
    dataArray = [c1 c2 c3];
    sortedData = sortrows(dataArray, -2);
    sortedData(size(sortedData, 1),:) = [];
    rank = cell(size(sortedData, 1), 1);
    for i = 1:size(sortedData, 1)
        rank(i) = num2cell(i);
    end
    header = {'Rank' 'Username' 'Questions' 'Percent Total'};
    questionStats = [header; [rank sortedData]];
else
    fprintf('There were no lines containing question marks during this period.\n');
    questionStats = {'Rank' 'Username' 'Questions' 'Percent Total'};
end

end