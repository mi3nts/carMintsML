
clc ; close all ; clear all 

display(newline)
display(newline)
display("---------------------MINTS---------------------")

addpath("../functions/")
addpath("../functions/YAMLMatlab_0.4.3")
mintsDefinitions  = ReadYaml('/home/teamlary/Documents/mintsDefinitions.yaml');

dataFolder = mintsDefinitions.dataFolder;
c1PlusID   = mintsDefinitions.c1PlusID;
airMarID   = mintsDefinitions.airMarID;
timeSpan   = seconds(mintsDefinitions.timeSpan);
sshPW      = mintsDefinitions.sshPW;
nasIP      = mintsDefinitions.nasIP;


referenceFolder          =  dataFolder + "/reference";
referenceDotMatsFolder   =  dataFolder + "/referenceMats";
licorFolder                =  referenceDotMatsFolder + "/licor"  ;


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Reference Data Located @: "+ referenceFolder)
display("Reference DotMat Data Located @ :"+ referenceDotMatsFolder)

display(newline)

%% Syncing Process 

% Needs to be connected to AV 
% syncFromNas(sshPW,nasIP,referenceFolder)


%% Finding Files 

licorFiles =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',c1PlusID,'_LICOR','*.csv'));

%% GPSGPGGA File Record
if(length(licorFiles) >0)
    
   parfor fileNameIndex = 1: length(licorFiles)
         try
            display("Reading: "+licorFiles(fileNameIndex).name+"- "+string(fileNameIndex))
            licorData{fileNameIndex} =  licorRead(strcat(licorFiles(fileNameIndex).folder,"/",licorFiles(fileNameIndex).name),timeSpan);
        catch
            display("Error With : "+licorFiles(fileNameIndex).name+" - "+string(fileNameIndex))
        end
    end
end

display(strcat("Concatinating LICOR Data"));

concatStr  =  "mintsDataAll = [";

 for fileNameIndex = 1:length(licorFiles)
    concatStr = strcat(concatStr,"licorData{",string(fileNameIndex),"};");
 end
 
 %% Filling In the Gaps
 
concatStr  =  strcat(concatStr,"];");
display(concatStr);
eval(concatStr);

display("Retiming Licor Data");
mintsDataAll   =  sortrows(unique(mintsDataAll)); 
mintsData      =  rmmissing(retime(mintsDataAll,'regular',@mean,'TimeStep',timeSpan)); 


%% Getting Save Name 
display("Saving Licor Data");
saveName  = strcat(licorFolder,'/licorAll.mat');
folderCheck(saveName)
save(saveName,'mintsDataAll');


saveName  = strcat(licorFolder,'/licor.mat');
folderCheck(saveName)
save(saveName,'mintsData');


%% Functions Used 

% 
% function mintsData = licorRead(fileName,timeSpan)
% 
%     %% Setup the Import Options and import the data
%     opts = delimitedTextImportOptions("NumVariables", 17);
% 
%     % Specify range and delimiter
%     opts.DataLines = [2, Inf];
%     opts.Delimiter = ",";
% 
%     % Specify column names and types
%     opts.VariableNames = ["dateTime", "timestamp", "latitudeCoordinate", "longitudeCoordinate", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "gpsQuality", "numberOfSatellites", "HorizontalDilution", "altitude", "altitudeUnits", "undulation", "undulationUnits", "age", "stationID"];
%     opts.VariableTypes = ["datetime", "datetime", "double", "double", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "categorical", "double", "categorical", "string", "string"];
% 
%     % Specify file level properties
%     opts.ExtraColumnsRule = "ignore";
%     opts.EmptyLineRule = "read";
% 
%     % Specify variable properties
%     opts = setvaropts(opts, ["age", "stationID"], "WhitespaceRule", "preserve");
%     opts = setvaropts(opts, ["latitudeDirection", "longitudeDirection", "altitudeUnits", "undulationUnits", "age", "stationID"], "EmptyFieldRule", "auto");
%     opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
%     opts = setvaropts(opts, "timestamp", "InputFormat", "HH:mm:ss");
% 
%     % Import the data
%     mintsData = readtable(fileName, opts);
%       
%            
%     mintsData = removevars( mintsData,{...    
%                    'timestamp'          ,...
%                    'latitude'           ,...
%                    'latitudeDirection'  ,...
%                    'longitude'          ,...
%                    'longitudeDirection' ,...
%                    'gpsQuality'         ,...
%                    'numberOfSatellites' ,...
%                    'HorizontalDilution' ,...       
%                    'altitudeUnits'      ,...
%                    'undulation'         ,...
%                    'undulationUnits'    ,...
%                    'age'                ,...
%                    'stationID'          }...
%                );
%            
%     
%     mintsData.dateTime.TimeZone = "utc";
% 
%     mintsData           = rmmissing(retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan));
%     fileParts = strsplit(fileName,'_');
%     mintsData.sensor(:) =fileParts(end-3);
% 
%    %% Clear temporary variables
%     clear opts
% 
% end
% 
% 
% function mintsData = gprmcRead(fileName,timeSpan)
%     %% Import data from text file
%     % Script for importing data from the following text file:
%     %
%     %    filename: /media/teamlary/teamlary1/gitHubRepos/carMintsML/firmware/dataProcessing/MINTS_001e0610c2e7_GPSGPRMC1_2020_04_04.csv
%     %
%     % Auto-generated by MATLAB on 26-Aug-2020 10:40:43
% 
%     %% Setup the Import Options and import the data
%     opts = delimitedTextImportOptions("NumVariables", 13);
% 
%     % Specify range and delimiter
%     opts.DataLines = [2, Inf];
%     opts.Delimiter = ",";
% 
%     % Specify column names and types
%     opts.VariableNames = ["dateTime", "timestamp", "status", "latitudeCoordinate", "longitudeCoordinate", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "speedOverGround", "trueCourse", "dateStamp", "magVariationDirection"];
%     opts.VariableTypes = ["datetime", "datetime", "categorical", "double", "double", "double", "categorical", "double", "categorical", "double", "string", "datetime", "string"];
% 
%     % Specify file level properties
%     opts.ExtraColumnsRule = "ignore";
%     opts.EmptyLineRule = "read";
% 
%     % Specify variable properties
%     opts = setvaropts(opts, ["trueCourse", "magVariationDirection"], "WhitespaceRule", "preserve");
%     opts = setvaropts(opts, ["status", "latitudeDirection", "longitudeDirection", "trueCourse", "magVariationDirection"], "EmptyFieldRule", "auto");
%     opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
%     opts = setvaropts(opts, "timestamp", "InputFormat", "HH:mm:ss");
%     opts = setvaropts(opts, "dateStamp", "InputFormat", "yyyy-MM-dd");
% 
%     % Import the data
%     mintsData = readtable(fileName, opts);
%         
%     mintsData = removevars( mintsData,{...    
%                     'timestamp',...
%                     'status'               ,...
%                     'latitude'             ,...
%                     'latitudeDirection'    ,...
%                     'longitude'            ,...
%                     'longitudeDirection'   ,...
%                     'speedOverGround'      ,...
%                     'trueCourse'           ,...
%                     'dateStamp'            ,...
%                     'magVariationDirection'}...
%                     );
%         
%     mintsData.dateTime.TimeZone = "utc";
% 
%     mintsData   =  rmmissing(retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan));
%     
%     % 
%     mintsData.altitude(:) =  nan;
%     
%     fileParts = strsplit(fileName,'_');
%     mintsData.sensor(:) =fileParts(end-3);
% 
%     
%  %% Clear temporary variables
%     clear opts      
% 
% end
% 
% 
% 
% %% Import data from text file
% % Script for importing data from the following text file:
% %
% %    filename: /media/teamlary/teamlary1/gitHubRepos/carMintsML/firmware/dataProcessing/MINTS_001e0610c2e9_GPGGA_2020_06_27.csv
% %
% % Auto-generated by MATLAB on 27-Aug-2020 08:12:37
% 
% function mintsData = gpggaAMRead(fileName,timeSpan)
% %% Setup the Import Options and import the data
%     opts = delimitedTextImportOptions("NumVariables", 16);
% 
%     % Specify range and delimiter
%     opts.DataLines = [2, Inf];
%     opts.Delimiter = ",";
% 
%     % Specify column names and types
%     opts.VariableNames = ["dateTime", "UTCTimeStamp", "latitude", "latDirection", "longitude", "lonDirection", "gpsQuality", "numberOfSatellites", "horizontalDilution", "altitude", "AUnits", "geoidalSeparation", "GSUnits", "ageOfDifferential", "stationID", "checkSum"];
%     opts.VariableTypes = ["datetime", "double", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "categorical", "double", "categorical", "string", "string", "double"];
% 
%     % Specify file level properties
%     opts.ExtraColumnsRule = "ignore";
%     opts.EmptyLineRule = "read";
% 
%     % Specify variable properties
%     opts = setvaropts(opts, ["ageOfDifferential", "stationID"], "WhitespaceRule", "preserve");
%     opts = setvaropts(opts, ["latDirection", "lonDirection", "AUnits", "GSUnits", "ageOfDifferential", "stationID"], "EmptyFieldRule", "auto");
%     opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
% 
%     % Import the data
%     mintsData = readtable(fileName, opts);
%     
%     mintsData.dateTime.TimeZone = "utc";
% 
%         
%     % Conversion to Coordinates 
%     mintsData.latitudeCoordinate = floor(mintsData.latitude/100)+ rem(mintsData.latitude,100)/60 ;
%     if mintsData.latDirection == 'S'
%         mintsData.latitudeCoordinate= mintsData.latitudeCoordinate *-1; 
%     end
%     mintsData.longitudeCoordinate = floor(mintsData.longitude/100)+ rem(mintsData.longitude,100)/60 ;
%     if mintsData.lonDirection == 'W'
%         mintsData.longitudeCoordinate= mintsData.longitudeCoordinate *-1; 
%     end
%     
%     
%     mintsData = removevars( mintsData,{...    
%                       'latitude'          ,...
%                       'latDirection'      ,...
%                       'longitude'         ,...
%                       'lonDirection'      ,...
%                       'UTCTimeStamp'      ,...
%                       'gpsQuality'        ,...
%                       'numberOfSatellites',...
%                       'horizontalDilution',...
%                       'AUnits'            ,...
%                       'geoidalSeparation' ,...
%                      'GSUnits'           ,...
%                      'ageOfDifferential' ,...
%                      'stationID'         ,...
%                      'checkSum'          ...
%                                     });
%     mintsData   =  rmmissing(retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan));
%     fileParts = strsplit(fileName,'_');
%     mintsData.sensor(:) =fileParts(end-3);
%     
%     
% 
%     %% Clear temporary variables
%     clear opts
% 
%     
%     
%     
% end
% 

