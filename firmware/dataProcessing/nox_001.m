
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
noxFolder                =  referenceDotMatsFolder + "/nox"  ;


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Reference Data Located @: "+ referenceFolder)
display("Reference DotMat Data Located @ :"+ referenceDotMatsFolder)

display(newline)

%% Syncing Process

% Needs to be connected to AV
% syncFromNas(sshPW,nasIP,referenceFolder)


%% Finding Files

noxFiles =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',c1PlusID,'_2B-NOX','*.csv'));

%% GPSGPGGA File Record
if(length(noxFiles) >0)
    
    parfor fileNameIndex = 1: length(noxFiles)
        try
            display("Reading: "+noxFiles(fileNameIndex).name+"- "+string(fileNameIndex))
            noxData{fileNameIndex} =  noxRead(strcat(noxFiles(fileNameIndex).folder,"/",noxFiles(fileNameIndex).name),timeSpan);
        catch
            display("Error With : "+noxFiles(fileNameIndex).name+" - "+string(fileNameIndex))
        end
    end
end

display(strcat("Concatinating nox Data"));

concatStr  =  "mintsDataAll = [";

for fileNameIndex = 1:length(noxFiles)
    concatStr = strcat(concatStr,"noxData{",string(fileNameIndex),"};");
end

%% Filling In the Gaps

concatStr  =  strcat(concatStr,"];");
display(concatStr);
eval(concatStr);

display("Retiming nox Data");
mintsDataAll   =  sortrows(unique(mintsDataAll));
mintsData      =  rmmissing(retime(mintsDataAll,'regular',@mean,'TimeStep',timeSpan));


%% Getting Save Name
display("Saving nox Data");
saveName  = strcat(noxFolder,'/noxAll.mat');
folderCheck(saveName)
save(saveName,'mintsDataAll');


saveName  = strcat(noxFolder,'/nox.mat');
folderCheck(saveName)
save(saveName,'mintsData');

