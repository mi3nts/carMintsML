%% GPS Data Record 

% Written bt Lakitha Wijeratne for MINTS 

% The following complies all GPS data from the car 
% and compliles them to one .mat file 

clc ; close all ; clear all 

display(newline)
display("---------------------MINTS---------------------")

addpath("../functions/")
addpath("../functions/YAMLMatlab_0.4.3")

% Make sure to edit the YAML File 
mintsDefinitions  = ReadYaml('/home/teamlary/Documents/mintsDefinitions.yaml');

dataFolder = mintsDefinitions.dataFolder;
c1PlusID   = mintsDefinitions.c1PlusID;
airMarID   = mintsDefinitions.airMarID;
roofTopXU4ID   = mintsDefinitions.roofTopXU4ID;
timeSpan   = seconds(mintsDefinitions.timeSpan);
sshPW      = mintsDefinitions.sshPW;
nasIP      = mintsDefinitions.nasIP;

referenceFolder          =  dataFolder + "/reference";
rawFolder                =  dataFolder + "/raw";
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
syncFromNas(sshPW,nasIP,referenceFolder,rawFolder)

%% Deleting data from an old XU4 ID 

system(strcat("rm -r ",rawFolder,"/",roofTopXU4ID,"/2016"));
system(strcat("rm -r ",rawFolder,"/",roofTopXU4ID,"/2020"));

%% Filling in the gaps for lost data 
% Pre Car GPS  
dateTime = datetime(2019,01,1,'timezone','utc'):seconds(30):datetime(2019,12,31,'timezone','utc');
preCarLatitude    = ones([length(dateTime),1])*32.992179;
preCarLongitude   = ones([length(dateTime),1])*-96.757777;
preCarGPS = timetable(dateTime',preCarLatitude,preCarLongitude);
preCarGPS.Properties.VariableNames = {'latitudeCoordinate','longitudeCoordinate'};
preCarGPS.altitude(:) = 220;
preCarGPS.sensor(:)   = "preDetermined";

dateTime = datetime(2020,06,27,'timezone','utc'):seconds(30):datetime(2020,06,28,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS1 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS1.Properties.VariableNames = {'latitudeCoordinate','longitudeCoordinate'};
postCarGPS1.altitude(:) = 220;
postCarGPS1.sensor(:)   = "preDetermined";

dateTime = datetime(2020,06,30,'timezone','utc'):seconds(30):datetime(2020,08,01,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS2 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS2.Properties.VariableNames ={'latitudeCoordinate','longitudeCoordinate'};
postCarGPS2.altitude(:) = 220;
postCarGPS2.sensor(:)   = "preDetermined";

dateTime = datetime(2020,08,27,'timezone','utc'):seconds(30):datetime(2020,09,30,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS3 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS3.Properties.VariableNames ={'latitudeCoordinate','longitudeCoordinate'};
postCarGPS3.altitude(:) = 220;
postCarGPS3.sensor(:)   = "preDetermined";

dateTime = datetime(2020,10,01,'timezone','utc'):seconds(30):datetime(2020,10,7,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS4 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS4.Properties.VariableNames ={'latitudeCoordinate','longitudeCoordinate'};
postCarGPS4.altitude(:) = 220;
postCarGPS4.sensor(:)   = "preDetermined";

dateTime = datetime(2020,10,08,'timezone','utc'):seconds(30):datetime(2020,11,1,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS5 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS5.Properties.VariableNames ={'latitudeCoordinate','longitudeCoordinate'};
postCarGPS5.altitude(:) = 220;
postCarGPS5.sensor(:)   = "preDetermined";
 
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
gpggaAM2Files =  dir(strcat(rawFolder,'/*/*/*/*/MINTS_',roofTopXU4ID,'_GPGGA','*.csv'))
% Addition of rooftop airmar files 



 display(" ---- ")
% 
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
    parfor fileNameIndex = 1:length(gprmcFiles)
        try
            display("Reading: "+gprmcFiles(fileNameIndex).name+ " " +string(fileNameIndex)) 
            GPSGPRMCData{fileNameIndex} =  gprmcRead(strcat(gprmcFiles(fileNameIndex).folder,"/",gprmcFiles(fileNameIndex).name),timeSpan);
        catch
            display("Error With : "+gprmcFiles(fileNameIndex).name+"- "+string(fileNameIndex))
        end   
    end
          
end  

 %% GPGGA File Record  *(Airmar 1)
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

 %% airmar File Record  (Airmar 2 )
 
 if(length(gpggaAM2Files) >0)
    parfor fileNameIndex = 1:length(gpggaAM2Files)
         try
            display("Reading: "+gpggaAM2Files(fileNameIndex).name+ " " +string(fileNameIndex)) 
            GPGGAAM2Data{fileNameIndex} =  gpggaAMRead(strcat(gpggaAM2Files(fileNameIndex).folder,"/",gpggaAM2Files(fileNameIndex).name),timeSpan)
        catch
            display("Error With : "+gpggaAM2Files(fileNameIndex).name+"- "+string(fileNameIndex))
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
 
  for fileNameIndex = 1: length(gpggaAM2Files)
     concatStr = strcat(concatStr,"GPGGAAM2Data{",string(fileNameIndex),"};");
 end   
 
 %% Filling In the Gaps 
 
concatStr  =  strcat(concatStr,"preCarGPS; postCarGPS1; postCarGPS2;postCarGPS3;postCarGPS4;postCarGPS5;postCarGPS6;];");

display(concatStr);
eval(concatStr);

display("Retiming GPS Data");

mintsDataAll   =  sortrows(unique(mintsDataAll)); 

mintsData   =  rmmissing(retime(removevars( mintsDataAll,{'sensor','altitude'}),'regular',@mean,'TimeStep',timeSpan)); 



%% CHANGE WHEN TESTING 
display("Saving GPS Data");
saveName  = strcat(GPSFolder,'/carMintsGPSAll_TEST.mat');
folderCheck(saveName)
save(saveName,'mintsDataAll');


%% Getting Save Name 
display("Saving GPS Data");
saveName  = strcat(GPSFolder,'/carMintsGPSCoords_TEST.mat');
folderCheck(saveName)
save(saveName,'mintsData');

%% Getting Save Name 
% display("Saving GPS Data");
% saveName  = strcat(GPSFolder,'/carMintsGPSAll.mat');
% folderCheck(saveName)
% save(saveName,'mintsDataAll');
% 
%  
% %% Getting Save Name 
% display("Saving GPS Data");
% saveName  = strcat(GPSFolder,'/carMintsGPSCoords.mat');
% folderCheck(saveName)
% save(saveName,'mintsData');


