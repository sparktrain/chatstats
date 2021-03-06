function [tourStats] = generateTourStats(chatFile)
% Tournament Statistics Generator
%   This function takes a .txt file of a Pok�mon Showdown chat log as
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
            if length(verticalBars) >= 4
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

if tourCreates > 0
    if tourCreates == 1
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
                if length(verticalBars) >= 4
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
    reverse = '';
    for i = 1:tourCreates
        for j = 1:length(uniqueTourFormats)
            if tourFormats(i) == uniqueTourFormats(j)
                tourFormatCount(j) = tourFormatCount(j) + 1;
                unique = false;
                break
            else
                unique = true;
            end
        end
        if unique
            uniqueTourFormats(length(uniqueTourFormats)+1) = tourFormats(i);
            tourFormatCount(length(uniqueTourFormats)) = 1;
        end
        progress = sprintf('%d/%d lines scanned\n', i, tourCreates);
        fprintf([reverse, progress]);
        reverse = repmat(sprintf('\b'), 1, length(progress));
    end

    tourFormatPercent = double.empty(0, tourCreates);
    for i = 1:length(tourFormatCount)
        tourFormatPercent(i) = 100 * (tourFormatCount(i) / tourCreates);
    end

    c1 = cell(uniqueTourFormats);
    c2 = num2cell(transpose(tourFormatCount));
    c3 = num2cell(transpose(tourFormatPercent));
    dataArray = [c1 c2 c3];
    sortedData = sortrows(dataArray, -2);
    sortedData(size(sortedData, 1),:) = [];
    rank = cell(size(sortedData, 1), 1);
    for i = 1:size(sortedData, 1)
        rank(i) = num2cell(i);
    end
    header = {'Rank' 'Format' '#' 'Percent Total'};
    tourStats = [header; [rank sortedData]];
else
    fprintf('There were no tournaments created during this period.\n');
    tourStats = {'Rank' 'Format' '#' 'Percent Total'};
end

end