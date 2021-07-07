function mintsData = gpggaRawRead(fileName, timeSpan)

%% Input handling

% If dataLines is not specified, define defaults

dataLines = [2, Inf];

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 16);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["dateTime", "UTCTimeStamp", "latitude", "latDirection", "longitude", "lonDirection", "gpsQuality", "numberOfSatellites", "horizontalDilution", "altitude", "AUnits", "geoidalSeparation", "GSUnits", "ageOfDifferential", "stationID", "checkSum"];
opts.VariableTypes = ["datetime", "double", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "categorical", "double", "categorical", "string", "string", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["ageOfDifferential", "stationID"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["latDirection", "lonDirection", "AUnits", "GSUnits", "ageOfDifferential", "stationID"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");

% Import the data % Import the data
mintsData = readtable(fileName, opts);

mintsData.latitudeCoordinate      =  floor(mintsData.latitude/100) + ...
                (mintsData.latitude - 100*(floor(mintsData.latitude/100)))/60;
mintsData.latitudeCoordinate = power(-1,mintsData.latDirection=="S").*mintsData.latitudeCoordinate;


mintsData.longitudeCoordinate     =  floor(mintsData.longitude/100) + ...
                (mintsData.longitude - 100*(floor(mintsData.longitude/100)))/60;
mintsData.longitudeCoordinate = power(-1,mintsData.lonDirection=="W").*mintsData.longitudeCoordinate;

mintsData = removevars( mintsData,{...    
                    'UTCTimeStamp'          ,...
                    'latitude'           ,...
                    'latDirection'       ,...
                    'longitude'          ,...
                    'lonDirection'       ,...
                    'gpsQuality'         ,...
                    'numberOfSatellites' ,...
                    'horizontalDilution' ,...
                    'AUnits'             ,...
                    'geoidalSeparation'  ,...
                    'GSUnits'            ,...
                    'ageOfDifferential'  ,...
                    'stationID'          ,...
                    'checkSum'             }...
               );
           

mintsData.dateTime.TimeZone = "utc";

mintsData           = rmmissing(retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan));
  
mintsData.sensor(:) ="airmar2";

end