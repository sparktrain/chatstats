function txtMerge(filePrefix)
% Text File Merger
%   This function merges multiple text files into one text file. More
%   specifically, this function is used to combine the daily chat logs into
%   one monthly chat log, or perhaps even a yearly chat log if you're
%   brave.
%
%   filePrefix is a string which specifies the prefix for the chat logs
%   you'd like to merge. For example, running txtMerge('2017-01') merges
%   all daily chat logs from January 2017 into one monthly chat log
%   entitled '2017-01.txt'.

fileList = struct2cell(dir('logs'));
fileNames = fileList(1, 1:length(fileList));
filesToMerge = [];
for i = 1:length(fileNames)
    fileName = char(fileNames(i));
    if length(filePrefix) <= length(fileName)
        if strcmp(fileName(1:length(filePrefix)), filePrefix) && strcmp(fileName(length(fileName)-3:length(fileName)), '.txt')
            filesToMerge = [filesToMerge {fileName}];
        end
    end
end

if isempty(filesToMerge)
    fprintf('There are no files matching the given file prefix.\n')
else
    fileText = [];
    for i = 1:length(filesToMerge)
        fid = fopen(char(strcat('logs/', filesToMerge(i))));
        fileText = [fileText transpose(fread(fid, '*char'))];
        if i ~= length(filesToMerge)
            fileText = [fileText 10]; % line break
        end
        fclose(fid);
    end
    mergedFile = ['logs/' filePrefix '.txt'];
    fid = fopen(mergedFile, 'w');
    fwrite(fid, fileText);
    fclose(fid);
    fprintf('%s.txt has been created.\n', filePrefix);
end

end