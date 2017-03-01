function [tourStats] = generateTourStats(chatFile)
% Tournament Statistics Generator
%   This function takes a .txt file of a Pokémon Showdown chat log as
%   input, then generates a list of tournament statistics.

tourLines = 0;
tourCreates = 0;
totalLines = 0;
fid = fopen(['logs/' chatFile]);
while feof(fid) == 0
    line = fgetl(fid);
    if length(line) >= 21
        if strcmp(line(10:21), '|tournament|')
            tourLines = tourLines + 1;
            verticalBars = strfind(line, '|');
            if length(verticalBars) >= 4;
                if strcmp(line(verticalBars(2):verticalBars(3)), '|create|')
                    tourCreates = tourCreates + 1;
                end
            end
        end
    end
    totalLines = totalLines + 1;
end
fclose(fid);
fprintf('The chat log has been scanned.\n');
fprintf('There are %d tournament lines and %d total lines.\n', tourLines, totalLines);

if tourCreates == 0;
    fprintf('There were no tournaments created during this period. How disappointing.\n');
    tourStats = 0;
else
    if tourCreates == 1;
            fprintf('There was 1 tournament created during this period.\n');
    else
            fprintf('There were %d tournaments created during this period.\n', tourCreates);
    end
    
    tourFormats = java_array('java.lang.String', tourCreates);
    currentChatLine = 1;
    fid = fopen(['logs/' chatFile]);
    while feof(fid) == 0
        line = fgetl(fid);
        if length(line) >= 21
            if strcmp(line(10:21), '|tournament|')
            verticalBars = strfind(line, '|');
                if length(verticalBars) >= 4;
                    if strcmp(line(verticalBars(2):verticalBars(3)), '|create|')
                        tourFormat = line((verticalBars(3) + 1):(verticalBars(4) - 1));
                        alphanumericTourFormat = lower(regexprep(tourFormat, '[^a-zA-Z0-9]', ''));
                        tourFormats(currentChatLine) = java.lang.String(alphanumericTourFormat);
                        currentChatLine = currentChatLine + 1;
                    end
                end
            end
        end
    end
    fclose(fid);
    fprintf('The tournament database has been generated.\n');

    uniqueTourFormats = java_array('java.lang.String', 1);
    tourFormatCount = double.empty(0, tourCreates);

    fprintf('Scanning the tournament database...\n');
    for i = 1:tourCreates
        x = 0;
        for j = 1:length(uniqueTourFormats)
            if tourFormats(i) == uniqueTourFormats(j)
                tourFormatCount(j) = tourFormatCount(j) + 1;
                x = x + 1;
            end
        end
        if x == 0
            uniqueTourFormats(length(uniqueTourFormats) + 1) = tourFormats(i);
            tourFormatCount(length(uniqueTourFormats)) = 1;
        end
        % if i == tourCreates || rem(i, 1) == 0
        %     fprintf('%d/%d lines scanned\n', i, tourCreates);
        % end
    end
    
    tourFormatPercent = double.empty(0,tourCreates);
    for i = 1:length(tourFormatCount)
        tourFormatPercent(i) = 100 * (tourFormatCount(i) / tourCreates);
    end
    
    d1 = cell(uniqueTourFormats);
    d2 = num2cell(transpose(tourFormatCount));
    d3 = num2cell(transpose(tourFormatPercent));
    
    dataArray = [d1 d2 d3];
    
    sortedData = sortrows(dataArray, -2);
    sortedData(size(sortedData, 1), :) = [];

    rank = cell(size(sortedData, 1), 1);
    for i = 1:size(sortedData, 1)
        rank(i) = num2cell(i);
    end

header = {'Rank' 'Format' '#' '%Total'};

tourStats = [header; [rank sortedData]];
end

end