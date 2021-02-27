
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
bcFolder                =  referenceDotMatsFolder + "/bc"  ;


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Reference Data Located @: "+ referenceFolder)
display("Reference DotMat Data Located @ :"+ referenceDotMatsFolder)

display(newline)

%% Syncing Process

% Needs to be connected to AV
% syncFromNas(sshPW,nasIP,referenceFolder)


%% Finding Files

bcFiles =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',c1PlusID,'_2B-BC','*.csv'));

%% GPSGPGGA File Record
if(length(bcFiles) >0)
    
    parfor fileNameIndex = 1: length(bcFiles)
        try
            display("Reading: "+bcFiles(fileNameIndex).name+"- "+string(fileNameIndex))
            bcData{fileNameIndex} =  bcRead(strcat(bcFiles(fileNameIndex).folder,"/",bcFiles(fileNameIndex).name),timeSpan);
        catch
            display("Error With : "+bcFiles(fileNameIndex).name+" - "+string(fileNameIndex))
        end
    end
end

display(strcat("Concatinating bc Data"));

concatStr  =  "mintsDataAll = [";

for fileNameIndex = 1:length(bcFiles)
    concatStr = strcat(concatStr,"bcData{",string(fileNameIndex),"};");
end

%% Filling In the Gaps

concatStr  =  strcat(concatStr,"];");
display(concatStr);
eval(concatStr);

display("Retiming bc Data");
mintsDataAll   =  sortrows(unique(mintsDataAll));
mintsData      =  rmmissing(retime(mintsDataAll,'regular',@mean,'TimeStep',timeSpan));


%% Getting Save Name
display("Saving bc Data");
saveName  = strcat(bcFolder,'/bcAll.mat');
folderCheck(saveName)
save(saveName,'mintsDataAll');


saveName  = strcat(bcFolder,'/bc.mat');
folderCheck(saveName)
save(saveName,'mintsData');

