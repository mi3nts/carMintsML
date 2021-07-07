function mintsData = bcRead(fileName,timeSpan)

% Input handling
dataLines = [2, Inf];


%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 14);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["dateTime", "Extinction880nm", "Extinction405nm", "BC", "PM", "temperature", "pressure", "humidity", "flowtemperature", "voltage880nm", "voltage405nm", "current405nm", "status", "sensorTime"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "sensorTime", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");

% Import the data
mintsData = readtable(fileName, opts);

mintsData = removevars( mintsData,...
    "sensorTime"       ...
    );

mintsData.dateTime.TimeZone = "utc";
mintsData           = rmmissing(retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan));


end