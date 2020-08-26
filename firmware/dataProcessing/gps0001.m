
clc ; close all ; clear all 


clc
clear all
close all
display(newline)
display(newline)
display("---------------------MINTS---------------------")

addpath("../functions/*")
addpath("../functions/YAMLMatlab_0.4.3")
mintsDefinitions  = ReadYaml('mintsDefinitions.yaml')

dataFolder = mintsDefinitions.dataFolder;
c1PlusID    = mintsDefinitions.c1PlusID;
timeSpan    = seconds(mintsDefinitions.timeSpan);


referenceFolder          =  dataFolder + "/reference";
referenceDotMatsFolder   =  dataFolder + "/referenceMats";
GPSFolder                =  referenceDotMatsFolder + "/" +c1PlusID ;


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Reference Data Located @: "+ referenceFolder)
display("Reference DotMat Data Located @ :"+ referenceDotMatsFolder)
display("Reference GPS Data Located @ :"+GPSFolder)


display(newline)

%% Syncing Process 

% syncFromCloudLora(gatewayIDs,dataFolder)

% going through the lora IDs
% for loraIDIndex = 1:length(loraIDs)

% loraID = loraIDs{loraIDIndex}; /media/teamlary/teamlary3/air930/mintsData/reference/001e0610c2e7/2020/02/04
gpggaFiles =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',c1PlusID,'_GPSGPGGA','*.csv'))
gprmcFiles =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',c1PlusID,'_GPSGPRMC','*.csv'))

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
    
display(strcat("Concatinating GPS Data"));
% 
concatStr  =  "mintsDataAll = [";
% 
 for fileNameIndex = 1: length(gpggaFiles)
     concatStr = strcat(concatStr,"GPSGPGGAData{",string(fileNameIndex),"};");
 end    
 for fileNameIndex = 1: length(gprmcFiles)
     concatStr = strcat(concatStr,"GPSGPRMCData{",string(fileNameIndex),"};");
 end    
 
concatStr  =  strcat(concatStr,"];");

display(concatStr);
eval(concatStr);

display("Retiming GPS Data");
mintsData   =  retime(unique(mintsDataAll),'regular',@mean,'TimeStep',timeSpan); 


%% Getting Save Name 
display("Saving GPS Data");
saveName  = strcat(GPSFolder,'/carGPS_',c1PlusID,'.mat');
folderCheck(saveName)
save(saveName,'mintsData');


function mintsData = gpggaRead(fileName,timeSpan)

    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 17);

    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["dateTime", "timestamp", "latitudeCoordinate", "longitudeCoordinate", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "gpsQuality", "numberOfSatellites", "HorizontalDilution", "altitude", "altitudeUnits", "undulation", "undulationUnits", "age", "stationID"];
    opts.VariableTypes = ["datetime", "datetime", "double", "double", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "categorical", "double", "categorical", "string", "string"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, ["age", "stationID"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["latitudeDirection", "longitudeDirection", "altitudeUnits", "undulationUnits", "age", "stationID"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
    opts = setvaropts(opts, "timestamp", "InputFormat", "HH:mm:ss");

    % Import the data
    mintsData = readtable(fileName, opts);
      
           
    mintsData = removevars( mintsData,{...    
                   'timestamp'          ,...
                   'latitude'           ,...
                   'latitudeDirection'  ,...
                   'longitude'          ,...
                   'longitudeDirection' ,...
                   'gpsQuality'         ,...
                   'numberOfSatellites' ,...
                   'HorizontalDilution' ,...       
                   'altitude'           ,...
                   'altitudeUnits'      ,...
                   'undulation'         ,...
                   'undulationUnits'    ,...
                   'age'                ,...
                   'stationID'          }...
               );
           
    
    mintsData.dateTime.TimeZone = "utc";

    mintsData   =  retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan);
     %% Clear temporary variables
    clear opts

end


function mintsData = gprmcRead(fileName,timeSpan)
    %% Import data from text file
    % Script for importing data from the following text file:
    %
    %    filename: /media/teamlary/teamlary1/gitHubRepos/carMintsML/firmware/dataProcessing/MINTS_001e0610c2e7_GPSGPRMC1_2020_04_04.csv
    %
    % Auto-generated by MATLAB on 26-Aug-2020 10:40:43

    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 13);

    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["dateTime", "timestamp", "status", "latitudeCoordinate", "longitudeCoordinate", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "speedOverGround", "trueCourse", "dateStamp", "magVariationDirection"];
    opts.VariableTypes = ["datetime", "datetime", "categorical", "double", "double", "double", "categorical", "double", "categorical", "double", "string", "datetime", "string"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, ["trueCourse", "magVariationDirection"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["status", "latitudeDirection", "longitudeDirection", "trueCourse", "magVariationDirection"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
    opts = setvaropts(opts, "timestamp", "InputFormat", "HH:mm:ss");
    opts = setvaropts(opts, "dateStamp", "InputFormat", "yyyy-MM-dd");

    % Import the data
    mintsData = readtable(fileName, opts);
        
    mintsData = removevars( mintsData,{...    
                    'timestamp',...
                    'status'               ,...
                    'latitude'             ,...
                    'latitudeDirection'    ,...
                    'longitude'            ,...
                    'longitudeDirection'   ,...
                    'speedOverGround'      ,...
                    'trueCourse'           ,...
                    'dateStamp'            ,...
                    'magVariationDirection'}...
                    );
        
    mintsData.dateTime.TimeZone = "utc";

    mintsData   =  retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan);
 %% Clear temporary variables
    clear opts      

end


%         display(strcat("Concatinating LoRa data for Node: ",loraID));
% 
%         concatStr  =  "mintsDataAll = [";
% 
%         for fileNameIndex = 1: length(allFiles)
%             concatStr = strcat(concatStr,"loraNodeAll{",string(fileNameIndex),"};");
%         end    
% 
%         concatStr  =  strcat(concatStr,"];");
% 
%         display(concatStr);
%         eval(concatStr);
% 
%         mintsData = unique(mintsDataAll);
% 
%         %% Getting Save Name 
%         display(strcat("Saving Lora Data for Node: ", loraID));
%         saveName  = strcat(loraMatsFolder,'/loraMints_',loraID,'.mat');
%         mkdir(fileparts(saveName));
%         save(saveName,'mintsData');
%     else
%         
%        display(strcat("No Data for Lora Node: ", loraID ))
%     end
%     
%     
%     clearvars -except loraIDs loraIDIndex rawFolder dataFolder rawDotMatsFolder loraMatsFolder
%     
% %loraID
% end




