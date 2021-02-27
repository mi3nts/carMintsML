
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
GPSFolder                =  referenceDotMatsFolder + "/carMintsGPS"  ;


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Reference Data Located @: "+ referenceFolder)
display("Reference DotMat Data Located @ :"+ referenceDotMatsFolder)
display("Reference GPS Data Located @ :"+GPSFolder)


display(newline)

%% Syncing Process 

% Needs to be connected to AV 
syncFromNas(sshPW,nasIP,referenceFolder)


%% Filling in the gaps for lost data 
% Pre Car GPS  
dateTime = datetime(2019,01,1,'timezone','utc'):seconds(30):datetime(2019,12,31,'timezone','utc');
preCarLatitude    = ones([length(dateTime),1])*32.992179;
preCarLongitude   = ones([length(dateTime),1])*-96.757777;
preCarGPS = timetable(dateTime',preCarLatitude,preCarLongitude);
preCarGPS.Properties.VariableNames = {'latitudeCoordinate','longitudeCoordinate'};
preCarGPS.altitude(:) = 220;
preCarGPS.sensor(:)   = "preDetermined";


% PostCarGPS1 
dateTime = datetime(2020,06,27,'timezone','utc'):seconds(30):datetime(2020,06,28,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS1 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS1.Properties.VariableNames = {'latitudeCoordinate','longitudeCoordinate'};
postCarGPS1.altitude(:) = 220;
postCarGPS1.sensor(:)   = "preDetermined";

% PostCarGPS2 - Skipping Server Transport -- Which was done on June 29th 
dateTime = datetime(2020,06,30,'timezone','utc'):seconds(30):datetime(2020,08,01,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS2 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS2.Properties.VariableNames ={'latitudeCoordinate','longitudeCoordinate'};
postCarGPS2.altitude(:) = 220;
postCarGPS2.sensor(:)   = "preDetermined";



% PostCarGPS2 - Skipping Server Transport -- Which was done on June 29th 
dateTime = datetime(2020,08,27,'timezone','utc'):seconds(30):datetime(2020,09,30,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS3 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS3.Properties.VariableNames ={'latitudeCoordinate','longitudeCoordinate'};
postCarGPS3.altitude(:) = 220;
postCarGPS3.sensor(:)   = "preDetermined";



% PostCarGPS2 - Skipping Server Transport -- Which was done on June 29th 
dateTime = datetime(2020,10,01,'timezone','utc'):seconds(30):datetime(2020,10,7,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS4 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS4.Properties.VariableNames ={'latitudeCoordinate','longitudeCoordinate'};
postCarGPS4.altitude(:) = 220;
postCarGPS4.sensor(:)   = "preDetermined";


% PostCarGPS2 - Skipping Server Transport -- Which was done on June 29th 
dateTime = datetime(2020,10,08,'timezone','utc'):seconds(30):datetime(2020,11,1,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS5 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS5.Properties.VariableNames ={'latitudeCoordinate','longitudeCoordinate'};
postCarGPS5.altitude(:) = 220;
postCarGPS5.sensor(:)   = "preDetermined";

% PostCarGPS2 - Skipping Server Transport -- Which was done on June 29th 
dateTime = datetime(2020,11,21,'timezone','utc'):seconds(30):datetime(2020,12,10,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS6 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS6.Properties.VariableNames ={'latitudeCoordinate','longitudeCoordinate'};
postCarGPS6.altitude(:) = 220;
postCarGPS6.sensor(:)   = "preDetermined";

%% Finding Files 

gpggaFiles =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',c1PlusID,'_GPSGPGGA','*.csv'))
gprmcFiles =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',c1PlusID,'_GPSGPRMC','*.csv'))
gpggaAMFiles =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',airMarID,'_GPGGA','*.csv'))



display(" ---- ")

%% GPSGPGGA File Record  
% 
    if(length(gpggaFiles) >0)
        
        parfor fileNameIndex = 1: length(gpggaFiles)
            try
                display("Reading: "+gpggaFiles(fileNameIndex).name+"- "+string(fileNameIndex))
                GPSGPGGAData{fileNameIndex} =  gpggaRead(strcat(gpggaFiles(fileNameIndex).folder,"/",gpggaFiles(fileNameIndex).name),timeSpan);
            catch
                display("Error With : "+gpggaFiles(fileNameIndex).name+" - "+string(fileNameIndex))
            end    
        end   
    end  

 %% GPSGPRMC File Record  
if(length(gprmcFiles) >0)
    parfor fileNameIndex = 1: length(gprmcFiles)
        try
            display("Reading: "+gprmcFiles(fileNameIndex).name+ " " +string(fileNameIndex)) 
            GPSGPRMCData{fileNameIndex} =  gprmcRead(strcat(gprmcFiles(fileNameIndex).folder,"/",gprmcFiles(fileNameIndex).name),timeSpan);
        catch
            display("Error With : "+gprmcFiles(fileNameIndex).name+"- "+string(fileNameIndex))
        end   
    end
          
end  
%     
% 
 %% GPGGA File Record  
if(length(gpggaAMFiles) >0)
    parfor fileNameIndex = 1: length(gpggaAMFiles)
         try
            display("Reading: "+gpggaAMFiles(fileNameIndex).name+ " " +string(fileNameIndex)) 
            GPGGAAMData{fileNameIndex} =  gpggaAMRead(strcat(gpggaAMFiles(fileNameIndex).folder,"/",gpggaAMFiles(fileNameIndex).name),timeSpan)
        catch
            display("Error With : "+gpggaAMFiles(fileNameIndex).name+"- "+string(fileNameIndex))
        end   
    end
          
end  


display(strcat("Concatinating GPS Data"));
% 
concatStr  =  "mintsDataAll = [";
% 
 for fileNameIndex = 1:length(gpggaFiles)
     concatStr = strcat(concatStr,"GPSGPGGAData{",string(fileNameIndex),"};");
 end    
 for fileNameIndex = 1:length(gprmcFiles)
     concatStr = strcat(concatStr,"GPSGPRMCData{",string(fileNameIndex),"};");
 end    
 
 for fileNameIndex = 1: length(gpggaAMFiles)
     concatStr = strcat(concatStr,"GPGGAAMData{",string(fileNameIndex),"};");
 end   
 
 %% Filling In the Gaps 
 
concatStr  =  strcat(concatStr,"preCarGPS; postCarGPS1; postCarGPS2;postCarGPS3;postCarGPS4;postCarGPS5;postCarGPS6;];");

display(concatStr);
eval(concatStr);

display("Retiming GPS Data");

mintsDataAll   =  sortrows(unique(mintsDataAll)); 

mintsData   =  rmmissing(retime(removevars( mintsDataAll,{'sensor','altitude'}),'regular',@mean,'TimeStep',timeSpan)); 


%% Getting Save Name 
display("Saving GPS Data");
saveName  = strcat(GPSFolder,'/carMintsGPSAll.mat');
folderCheck(saveName)
save(saveName,'mintsDataAll');



%% Getting Save Name 
display("Saving GPS Data");
saveName  = strcat(GPSFolder,'/carMintsGPSCoords.mat');
folderCheck(saveName)
save(saveName,'mintsData');


%% Functions Used 

% 
% function mintsData = gpggaRead(fileName,timeSpan)
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
