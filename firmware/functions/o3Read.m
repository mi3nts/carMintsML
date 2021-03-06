function mintsData = o3Read(fileName,timeSpan)


%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["dateTime", "ozone", "temperature", "pressure", "voltage", "sensorTime"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "sensorTime", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "sensorTime", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
% Import the data
% Import the data
mintsData = readtable(fileName, opts);

mintsData = removevars( mintsData,...
    "sensorTime"       ...
    );

mintsData.dateTime.TimeZone = "utc";
mintsData           = rmmissing(retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan));


end